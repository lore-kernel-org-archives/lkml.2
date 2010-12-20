Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0LTUFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:05:09 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:43958 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932744Ab0LTUFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:05:08 -0500
Message-ID: <4D0FB6E6.2060608@metafoo.de>
Date: Mon, 20 Dec 2010 21:04:54 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] power/gpio-charger: check for kzalloc() failure
References: <20101220130856.GZ1936@bicker>
In-Reply-To: <20101220130856.GZ1936@bicker>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/20/2010 02:08 PM, Dan Carpenter wrote:
> Return -ENOMEM if kzalloc() fails.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index fccbe99..06a74f0 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -87,6 +87,8 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
>  	}
>  
>  	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
> +	if (!gpio_charger)
> +		return -ENOMEM;
>  
>  	charger = &gpio_charger->charger;
>  

Hi

This is now the 4th patch or so fixing this issue. I send the first one[1], together
with some other fixes[2][3], a month ago.

Anton could you please pick them up?

Thanks
- - Lars

[1] http://lkml.indiana.edu/hypermail/linux/kernel/1011.2/02029.html
[2] http://lkml.indiana.edu/hypermail/linux/kernel/1011.2/02028.html
[3] http://lkml.indiana.edu/hypermail/linux/kernel/1011.2/02030.html

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0PtuYACgkQBX4mSR26RiOCRQCfdKUdpAjX2GxAJuGVekZDiyjx
j3IAnRCS562ud3Ali/B5V1gWNeBHcxNj
=M4Vg
-----END PGP SIGNATURE-----
