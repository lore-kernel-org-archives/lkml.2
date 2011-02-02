Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1BBQhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:37:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65409 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1BBQhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:37:07 -0500
Date: Wed, 2 Feb 2011 14:37:34 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH] ath3k: Avoid duplication of code
Message-ID: <20110202163734.GE2273@joana>
References: <20110127232453.GA3531@ime.usp.br>
 <4D4284D7.8000200@ahsoftware.de>
 <20110128221807.GA9741@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110128221807.GA9741@ime.usp.br>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rogério,

* Rogério Brito <rbrito@ime.usp.br> [2011-01-28 20:18:10 -0200]:

> 
> Hi.
> 
> In commit 86e09287e4f8c81831b4d4118a48597565f0d21b, to reduce memory
> usage, the functions of the ath3k module were rewritten to release the
> firmware blob after it has been loaded (successfully or not).
> 
> The resuting code has some redundancy and the compiler can potentially
> produce better code if we omit a function call that is unconditionally
> executed in
> 
> ,----
> | 	if (ath3k_load_firmware(udev, firmware)) {
> | 		release_firmware(firmware);
> | 		return -EIO;
> |	}
> |	release_firmware(firmware);
> |
> |	return 0;
> | }
> `----
> 
> It may also be argued that the rewritten code becomes easier to read,
> and also to see the code coverage of the snippet in question.
> 
> 
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
> Cc: Alexander Holler <holler@ahsoftware.de>
> Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
> Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Please send me your patch in a 'git format-patch' way, so I can apply it
without having to edit the commit message. And add "Bluetooth:" to the
beginning of the commit title.

> 
> ---
> 
> Thanks for all the feedback on the previous patches. The one that didn't
> compile before was sent without a hunk. This time everything all the
> basics are verified.
> 
> 
> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index a126e61..42fa531 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -106,6 +106,7 @@ static int ath3k_probe(struct usb_interface *intf,
>  {
>  	const struct firmware *firmware;
>  	struct usb_device *udev = interface_to_usbdev(intf);
> +	int ret;
>  
>  	BT_DBG("intf %p id %p", intf, id);
>  
> @@ -116,13 +117,10 @@ static int ath3k_probe(struct usb_interface *intf,
>  		return -EIO;
>  	}
>  
> -	if (ath3k_load_firmware(udev, firmware)) {
> -		release_firmware(firmware);
> -		return -EIO;
> -	}
> +	ret = ath3k_load_firmware(udev, firmware);
>  	release_firmware(firmware);
>  
> -	return 0;
> +	return ret ? -EIO : 0;

just return ret;
It is enough.

Regards,

-- 
Gustavo F. Padovan
http://profusion.mobi
