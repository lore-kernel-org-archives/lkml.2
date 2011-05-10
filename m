Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1EJX4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:56:14 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:55663 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753518Ab1EJX4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:56:13 -0400
Date: Wed, 11 May 2011 01:45:26 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Maxim Osipov <maxim.osipov@gmail.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91: Add external RTC for Flexibity board
Message-ID: <20110510234526.GC18929@game.jcrosoft.org>
References: <4DC53134.8070706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC53134.8070706@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15031045233316375522
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:47 Sat 07 May     , Maxim Osipov wrote:
> Hello,
> 
> This patch enables external RTC support on AT91 Flexibity board.
> 
> Kind regards,
> Maxim
> 
> 
> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
> ---
>  arch/arm/mach-at91/board-flexibity.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
> index c8a62dc..4fdc96c 100644
> --- a/arch/arm/mach-at91/board-flexibity.c
> +++ b/arch/arm/mach-at91/board-flexibity.c
> @@ -1,7 +1,7 @@
>  /*
>   * linux/arch/arm/mach-at91/board-flexibity.c
>   *
> - *  Copyright (C) 2010 Flexibity
> + *  Copyright (C) 2010-2011 Flexibity
>   *  Copyright (C) 2005 SAN People
>   *  Copyright (C) 2006 Atmel
>   *
> @@ -65,6 +65,13 @@ static struct at91_udc_data __initdata flexibity_udc_data = {
>  	.pullup_pin	= 0,		/* pull-up driven by UDC */
>  };
>  
> +/* I2C devices */
> +static struct i2c_board_info __initdata flexibity_i2c_devices[] = {
> +	{
> +		I2C_BOARD_INFO("ds1307", 0x68),
> +	},
> +};
> +
looks fine just one comment please add your board to the new at91sam9260_defconfig

so we can compile it when compiling all the sam9260

Best Regards,
J.
