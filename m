Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab1BZRNp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 12:13:45 -0500
Received: from mailc.microsoft.com ([131.107.115.214]:57243 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1BZRNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 12:13:31 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <error27@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
Thread-Topic: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
Thread-Index: AQHL1ViS3KVTojE7hESxh/U9QG1BvZQTp0KAgAAtipA=
Date: Sat, 26 Feb 2011 17:13:31 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048015780@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1298685992-30864-1-git-send-email-kys@microsoft.com>
 <20110226033323.GD18043@bicker>
In-Reply-To: <20110226033323.GD18043@bicker>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Friday, February 25, 2011 10:33 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
> 
> On Fri, Feb 25, 2011 at 06:06:32PM -0800, K. Y. Srinivasan wrote:
> > Cleanup the names of variables that refer to the
> > hyperv_device abstraction.
> >
> 
> I have a script I run on rename patches.  For this patch the
> command would be:
> 
> rename_rev.pl -nc -e 's/device_ctx/device_obj/g' -e 's/\bdev_ctx/dev/g'
> 
> It show one variable was missed in storvsc_probe().
> 
> >  	memset(host_device_ctx, 0, sizeof(struct host_device_context));
> >
> >  	host_device_ctx->port = host->host_no;
> > -	host_device_ctx->device_ctx = device_obj;
> > +	host_device_ctx->device_obj = device_obj;
> >
> >  	host_device_ctx->request_pool =
> >  				kmem_cache_create(dev_name(&device_obj-
> >device),
> > @@ -271,7 +271,7 @@ static int storvsc_probe(struct device *device)
> >  		return -1;
> >  	}
> >
> > -	/* host_device_ctx->port = device_info.PortNumber; */
> > +	/* host_hyperv_dev->port = device_info.PortNumber; */
> >  	host_device_ctx->path = device_info.path_id;
> >  	host_device_ctx->target = device_info.target_id;
> >
> 
> All the other host_device_ctx variables were renamed to host_device_obj.

host_device_ctx is a scsi abstraction built on top of the hyperv_device
abstraction. My goal was not to change the names of higher level scsi
abstractions.

Regards,

K. Y
> 
> regards,
> dan carpenter

