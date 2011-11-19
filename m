Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1KSXn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 18:43:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab1KSXn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 18:43:26 -0500
Date: Sun, 20 Nov 2011 00:43:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Use kmemdup rather than duplicating its
 implementation
In-Reply-To: <1321569820.1624.281.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1111200043140.15187@pobox.suse.cz>
References: <1321569820.1624.281.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Thomas Meyer wrote:

> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
> --- a/drivers/hid/hid-roccat-common.c 2011-11-07 19:39:05.364461084 +0100
> +++ b/drivers/hid/hid-roccat-common.c 2011-11-08 10:45:42.781966362 +0100
> @@ -49,12 +49,10 @@ int roccat_common_send(struct usb_device
>  	char *buf;
>  	int len;
>  
> -	buf = kmalloc(size, GFP_KERNEL);
> +	buf = kmemdup(data, size, GFP_KERNEL);
>  	if (buf == NULL)
>  		return -ENOMEM;
>  
> -	memcpy(buf, data, size);
> -
>  	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
>  			HID_REQ_SET_REPORT,
>  			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
> diff -u -p a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> --- a/drivers/hid/hid-roccat-kone.c 2011-11-07 19:37:44.826571091 +0100
> +++ b/drivers/hid/hid-roccat-kone.c 2011-11-08 10:45:45.085330572 +0100
> @@ -78,12 +78,10 @@ static int kone_send(struct usb_device *
>  	char *buf;
>  	int len;
>  
> -	buf = kmalloc(size, GFP_KERNEL);
> +	buf = kmemdup(data, size, GFP_KERNEL);
>  	if (buf == NULL)
>  		return -ENOMEM;
>  
> -	memcpy(buf, data, size);
> -
>  	len = usb_control_msg(usb_dev, usb_sndctrlpipe(usb_dev, 0),
>  			HID_REQ_SET_REPORT,
>  			USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs
