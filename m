Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1BVRMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:12:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61561 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1BVRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:12:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 11/12] unicore32 machine related files: ps2 driver
Date: Tue, 22 Feb 2011 18:11:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, "'Greg KH'" <greg@kroah.com>
References: <015701cbcdae$7d5f43f0$781dcbd0$@mprc.pku.edu.cn> <201102181133.26675.arnd@arndb.de> <019001cbd29c$7cee6340$76cb29c0$@mprc.pku.edu.cn>
In-Reply-To: <019001cbd29c$7cee6340$76cb29c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221811.58441.arnd@arndb.de>
X-Provags-ID: V02:K0:l6Ux3v07Gh9XhmdF+TN5qjlHWvbYE5yI6uhV+G8lVUD
 Wg1KnPpmStLCIx7COqrjq3AFX9ZWiZ87G0rX5BWVd8wpFAZfs/
 o+HY9I410ZiL1Z2mQjhdvKyjwxwPxXEAyc/GUN+7XSHSNwclkP
 SuAfIUa6h8JH/nRiTHtQmG9RrPzS/MIVgNpkv5ocv4zcvHzu0X
 9LD869KGhhF6bB8xs4XLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 February 2011, Guan Xuetao wrote:
> diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
> index 2cdd872..9350843 100644
> --- a/drivers/input/serio/i8042-unicore32io.h
> +++ b/drivers/input/serio/i8042-unicore32io.h
> @@ -29,11 +29,11 @@
>  /*
>   * Register numbers.
>   */
> -#define I8042_COMMAND_REG      ((volatile void __iomem *)&PS2_COMMAND)
> -#define I8042_STATUS_REG       ((volatile void __iomem *)&PS2_STATUS)
> -#define I8042_DATA_REG         ((volatile void __iomem *)&PS2_DATA)
> +#define I8042_COMMAND_REG      PS2_COMMAND
> +#define I8042_STATUS_REG       PS2_STATUS
> +#define I8042_DATA_REG         PS2_DATA

I wouldn't bother defining two sets of macros then. Either use PS2_COMMAND
in the driver, or define I8042_COMMAND_REG in the place where you currently
define PS2_COMMAND.

Aside from this, it looks good.

	Arnd
