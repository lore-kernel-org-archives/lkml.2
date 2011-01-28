Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1A1I5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:57:07 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:38166 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1A1I5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:57:05 -0500
Message-ID: <4D4284D7.8000200@ahsoftware.de>
Date: Fri, 28 Jan 2011 09:56:55 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>
CC: linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: Re: [PATCH 02/02] ath3k: Avoid duplication of code
References: <20110127232453.GA3531@ime.usp.br>
In-Reply-To: <20110127232453.GA3531@ime.usp.br>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rogério,

Am 28.01.2011 00:24, schrieb Rogério Brito:

> The resuting code has some redundancy and the compiler can potentially
> produce better code if we omit a function call that is unconditionally
> executed in


> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index a126e61..d51c5a3 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -116,13 +116,10 @@ static int ath3k_probe(struct usb_interface *intf,
>   		return -EIO;
>   	}
>
> -	if (ath3k_load_firmware(udev, firmware)) {
> -		release_firmware(firmware);
> -		return -EIO;
> -	}
> +	ret = ath3k_load_firmware(udev, firmware);
>   	release_firmware(firmware);
>
> -	return 0;
> +	return ret ? -EIO : 0;
>   }

Looks nice, but doesn't compile. I assume you should at least try to 
compile the stuff you want to change. ;)

Regards,

Alexander

