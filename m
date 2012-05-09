Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab2EIP5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:57:32 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:41041 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2EIP52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:57:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-131.messagelabs.com!1336578951!21913514!74
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Wed, 9 May 2012 10:56:54 -0500
Subject: RE: [PATCH] staging: comedi: refactor sysfs files in comedi_fops.c
Thread-Topic: [PATCH] staging: comedi: refactor sysfs files in comedi_fops.c
Thread-Index: Ac0tieoyDogQyEn0Rzu48ChUVouXswAcfrrg
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698A1786A@AUSP01VMBX24.collaborationhost.net>
References: <201205081916.51659.hartleys@visionengravers.com>
In-Reply-To: <201205081916.51659.hartleys@visionengravers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012 7:17 PM, H Hartley Sweeten wrote:
>
> Refactor the sysfs attributes and functions to remove
> the need for the forward declarations and use the
> DEVICE_ATTR macro to define them.
>
> Instead of individually creating sysfs device attribute
> files, wrap them in an attribute_group and use the
> sysfs_create_group function to create them.
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Mori Hess <fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---

Oops... spotted a copy-paste error after I posted this.

<snip>

> @@ -2367,42 +2620,15 @@ int comedi_alloc_subdevice_minor(struct comedi_device *dev,
>  	if (!IS_ERR(csdev))
>  		s->class_dev = csdev;
>  	dev_set_drvdata(csdev, info);
> -	retval = device_create_file(csdev, &dev_attr_max_read_buffer_kb);
> +
> +	retval = sysfs_create_group(&csdev->kobj, &comedi_sysfs_files);
>  	if (retval) {
>  		printk(KERN_ERR
> -		       "comedi: "
> -		       "failed to create sysfs attribute file \"%s\".\n",
> -		       dev_attr_max_read_buffer_kb.attr.name);
> -		comedi_free_subdevice_minor(s);
> -		return retval;
> -	}
> -	retval = device_create_file(csdev, &dev_attr_read_buffer_kb);
> -	if (retval) {
> -		printk(KERN_ERR
> -		       "comedi: "
> -		       "failed to create sysfs attribute file \"%s\".\n",
> -		       dev_attr_read_buffer_kb.attr.name);
> -		comedi_free_subdevice_minor(s);
> -		return retval;
> -	}
> -	retval = device_create_file(csdev, &dev_attr_max_write_buffer_kb);
> -	if (retval) {
> -		printk(KERN_ERR
> -		       "comedi: "
> -		       "failed to create sysfs attribute file \"%s\".\n",
> -		       dev_attr_max_write_buffer_kb.attr.name);
> -		comedi_free_subdevice_minor(s);
> -		return retval;
> -	}
> -	retval = device_create_file(csdev, &dev_attr_write_buffer_kb);
> -	if (retval) {
> -		printk(KERN_ERR
> -		       "comedi: "
> -		       "failed to create sysfs attribute file \"%s\".\n",
> -		       dev_attr_write_buffer_kb.attr.name);
> -		comedi_free_subdevice_minor(s);
> +		       "comedi: failed to create sysfs attribute files\n");
> +		comedi_free_board_minor(i);

This should still be:

		comedi_free_subdevice_minor(s);

I'll fix it and re-post.

>  		return retval;
>  	}
> +
>  	return i;
>  }

Regards,
Hartley

 
