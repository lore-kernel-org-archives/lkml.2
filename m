Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2IDQ2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:28:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59875 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab2IDQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:28:09 -0400
X-Originating-IP: 108.223.40.66
Date: Tue, 4 Sep 2012 09:28:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/2] hwmon/lm70: Allow 4wire SPI bus with LM70
Message-ID: <20120904162812.GB16877@roeck-us.net>
References: <201209040840.q848eiPg028975@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209040840.q848eiPg028975@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 10:40:44AM +0200, Christophe Leroy wrote:
> Removing the 3wire limitation on LM70 as the component also allows
> operation on 4wire SPI bus
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
Applied to -next.

Thanks,
Guenter

> diff -u linux-3.5-vanilla/drivers/hwmon/lm70.c linux-3.5/drivers/hwmon/lm70.c
> --- linux-3.5-vanilla/drivers/hwmon/lm70.c	2012-07-21 22:58:29.000000000 +0200
> +++ linux-3.5/drivers/hwmon/lm70.c	2012-08-25 00:35:40.000000000 +0200
> @@ -143,10 +143,6 @@
>  	if (spi->mode & (SPI_CPOL | SPI_CPHA))
>  		return -EINVAL;
>  
> -	/* 3-wire link (shared SI/SO) for LM70 */
> -	if (chip == LM70_CHIP_LM70 && !(spi->mode & SPI_3WIRE))
> -		return -EINVAL;
> -
>  	/* NOTE:  we assume 8-bit words, and convert to 16 bits manually */
>  
>  	p_lm70 = kzalloc(sizeof *p_lm70, GFP_KERNEL);
> diff -u linux-3.5-vanilla/Documentation/hwmon/lm70 linux-3.5/Documentation/hwmon/lm70
> --- linux-3.5-vanilla/Documentation/hwmon/lm70	2012-07-21 22:58:29.000000000 +0200
> +++ linux-3.5/Documentation/hwmon/lm70	2012-08-25 00:37:15.000000000 +0200
> @@ -31,9 +31,8 @@
>  with a "SPI master controller driver", see drivers/spi/spi_lm70llp.c
>  and its associated documentation.
>  
> -The TMP121/TMP123 are very similar; main differences are 4 wire SPI inter-
> -face (read only) and 13-bit temperature data (0.0625 degrees celsius reso-
> -lution).
> +The TMP121/TMP123 are very similar; main difference is 13-bit temperature
> +data (0.0625 degrees celsius resolution).
>  
>  Thanks to
>  ---------
> 
