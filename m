Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2EXQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:22:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46303 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab2EXQWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:22:50 -0400
Date: Thu, 24 May 2012 18:22:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drop superfluous setting of i2c_board_info.type
Message-ID: <20120524162230.GU3710@pengutronix.de>
References: <1337870303.22505.20.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337870303.22505.20.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 04:38:23PM +0200, Paul Bolle wrote:
> Three instances of struct i2c_board_info have their "type" member set to
> "tsc2007" twice. First through the I2C_BOARD_INFO macro and then
> directly. Drop the superfluous second setting.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Entirely untested. I'm unsure what toolchain(s) is (are) needed to
> compile this and I am certain that I don't have the hardware.
> 
> 1) This is apparently legal. Doesn't gcc issue a warning for this?
I wondered about that too, gcc doesn't even warn when the two values are
different. See for example commit
bd9e310dca15c9987256f67af19f9f42426e7493.
> 
>  arch/arm/mach-imx/mach-cpuimx35.c     |    1 -
>  arch/arm/mach-imx/mach-cpuimx51sd.c   |    1 -
I already submitted a patch for the imx bits with Message id
1335989287-10094-1-git-send-email-u.kleine-koenig@pengutronix.de.
(e.g.
http://mid.gmane.org/1335989287-10094-1-git-send-email-u.kleine-koenig@pengutronix.de)

Don't know if Sascha took it already. If he did, he didn't tell me.

Best regards
Uwe
>  arch/arm/mach-shmobile/board-ap4evb.c |    1 -
>  3 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mach-cpuimx35.c b/arch/arm/mach-imx/mach-cpuimx35.c
> index 8ecc872..b1a4796 100644
> --- a/arch/arm/mach-imx/mach-cpuimx35.c
> +++ b/arch/arm/mach-imx/mach-cpuimx35.c
> @@ -70,7 +70,6 @@ static struct i2c_board_info eukrea_cpuimx35_i2c_devices[] = {
>  		I2C_BOARD_INFO("pcf8563", 0x51),
>  	}, {
>  		I2C_BOARD_INFO("tsc2007", 0x48),
> -		.type		= "tsc2007",
>  		.platform_data	= &tsc2007_info,
>  		.irq		= IMX_GPIO_TO_IRQ(TSC2007_IRQGPIO),
>  	},
> diff --git a/arch/arm/mach-imx/mach-cpuimx51sd.c b/arch/arm/mach-imx/mach-cpuimx51sd.c
> index 9fbe923..89eb93c 100644
> --- a/arch/arm/mach-imx/mach-cpuimx51sd.c
> +++ b/arch/arm/mach-imx/mach-cpuimx51sd.c
> @@ -124,7 +124,6 @@ static struct i2c_board_info eukrea_cpuimx51sd_i2c_devices[] = {
>  		I2C_BOARD_INFO("pcf8563", 0x51),
>  	}, {
>  		I2C_BOARD_INFO("tsc2007", 0x49),
> -		.type		= "tsc2007",
>  		.platform_data	= &tsc2007_info,
>  		.irq		= IMX_GPIO_TO_IRQ(TSC2007_IRQGPIO),
>  	},
> diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
> index b56dde2..801de4b 100644
> --- a/arch/arm/mach-shmobile/board-ap4evb.c
> +++ b/arch/arm/mach-shmobile/board-ap4evb.c
> @@ -1168,7 +1168,6 @@ static struct tsc2007_platform_data tsc2007_info = {
>  
>  static struct i2c_board_info tsc_device = {
>  	I2C_BOARD_INFO("tsc2007", 0x48),
> -	.type		= "tsc2007",
>  	.platform_data	= &tsc2007_info,
>  	/*.irq is selected on ap4evb_init */
>  };
> -- 
> 1.7.7.6
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
