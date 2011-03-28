Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1C1Re3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:34:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1C1Re1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:34:27 -0400
Date: Mon, 28 Mar 2011 13:34:24 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Steven Hardy <shardy@redhat.com>
Cc: gregkh@suse.de, mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] Fix memory leak in qcserial driver
Message-ID: <20110328173422.GA6354@redhat.com>
References: <1301321186.4397.13.camel@shardy.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301321186.4397.13.camel@shardy.csb>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 03:06:26PM +0100, Steven Hardy wrote:
> @@ -198,13 +200,27 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>  	default:
>  		dev_err(&serial->dev->dev,
>  			"unknown number of interfaces: %d\n", nintf);
> +		retval = -ENODEV;
>  		kfree(data);
> -		return -ENODEV;
>  	}
>  
> +	/* Set serial->private may be null if -ENODEV */
> +	usb_set_serial_data(serial, data);
>  	return retval;
>  }
when there's a -ENODEV, kfree() is called but the now invalid address is
set by usb_set_serial_data() anyway. am I missing something here?

-- 
Aristeu

