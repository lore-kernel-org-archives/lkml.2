Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1BIIuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:50:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64463 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1BIIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 03:50:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IS2jqB0eHV6uKslmT10few+pwuZTJtMRGSZMKhjcQZbjWz6Avu/63A1J4V3bzLgbb/
         +5jxRGKaFVS5yUBPTsifx/VeM9Yyr+DS9z7NBgQCCBYnYNdrlJHtZ3n0LLmsh5iAP/bo
         8UMmSZtmP+07nXn9V9Yj8x5E1m5E/BiazhnRQ=
Date: Wed, 9 Feb 2011 00:50:07 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alexander Strakh <cromlehg@gmail.com>
Cc: rydberg@euromail.se, oneukum@suse.de, oblivian@users.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Strakh <strakh@ispras.ru>
Subject: Re: [PATCH 1/1] Fix error path in wacom_probe
Message-ID: <20110209085007.GC7256@core.coreip.homeip.net>
References: <1297237048-32714-1-git-send-email-strakh@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297237048-32714-1-git-send-email-strakh@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:37:28AM +0300, Alexander Strakh wrote:
> From: Alexander Strakh <cromlehg@gmail.com>
> 
>   In file drivers/input/tablet/wacom_sys.c in
> wacom_probe after error we can goto label2. In
>  this case function usb_free was not called. 
>  It will be right goto for the label tail3.
> 
>         wacom->irq = usb_alloc_urb(0, GFP_KERNEL);
> 
> 	...
> 
>         /* Retrieve the physical and logical size for OEM devices */
>         error = wacom_retrieve_hid_descriptor(intf, features);
>         if (error)
>                 goto fail2;
> 	...
> 	 fail3: usb_free_urb(wacom->irq);
> 	 fail2: usb_free_coherent(dev, WACOM_PKGLEN_MAX, wacom_wac->data, wacom->data_dma);
> 
> Replaced wrong transition.
> 
> Signed-off-by: Alexander Strakh <strakh@ispras.ru>

Will apply, thank you.

> ---
>  drivers/input/tablet/wacom_sys.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index fc38149..cf8fb9f 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -519,7 +519,7 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
>  	/* Retrieve the physical and logical size for OEM devices */
>  	error = wacom_retrieve_hid_descriptor(intf, features);
>  	if (error)
> -		goto fail2;
> +		goto fail3;
>  
>  	wacom_setup_device_quirks(features);
>  
> -- 
> 1.7.1
> 

-- 
Dmitry
