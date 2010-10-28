Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab0J1U7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:59:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35709 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933674Ab0J1U7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:59:46 -0400
Date: Thu, 28 Oct 2010 22:59:45 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        amit.kucheria@canonical.com, eric@eukrea.com
Subject: Re: [PATCH] ARM: imx: Fix GPIO_1_xx settings that are wrongly
	assumed
Message-ID: <20101028205945.GE31158@pengutronix.de>
References: <1288296137-1995-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1288296137-1995-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dinh,

On Thu, Oct 28, 2010 at 03:02:17PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Its not a same assumption that because because 1 gpio mux is at
> mux mode 1, that it is the same for all gpio's. Freescale HW
> engineers like to keep things interesting by varying the mux mode
> of the gpio's.
> 
> Reference: The iomux-mx51.h file is generated from a script that
> converts the pin mode file from the SoC HW designers.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/plat-mxc/include/mach/iomux-mx51.h |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> index e46b1c2..056ba0f 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> @@ -368,18 +368,18 @@ typedef enum iomux_config {
>  							MX51_SDHCI_PAD_CTRL)
>  #define MX51_PAD_GPIO_1_0__GPIO_1_0		IOMUX_PAD(0x7B4, 0x3AC, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
>  #define MX51_PAD_GPIO_1_1__GPIO_1_1		IOMUX_PAD(0x7B8, 0x3B0, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_2__GPIO_1_2		IOMUX_PAD(0x7D4, 0x3CC, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_2__GPIO_1_2		IOMUX_PAD(0x7D4, 0x3CC, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
>  #define MX51_PAD_GPIO_1_2__I2C2_SCL		IOMUX_PAD(0x7D4, 0x3CC, (2 | IOMUX_CONFIG_SION), \
>  							0x9b8,   3, MX51_I2C_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_3__GPIO_1_3		IOMUX_PAD(0x7D8, 0x3D0, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_3__GPIO_1_3		IOMUX_PAD(0x7D8, 0x3D0, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
>  #define MX51_PAD_GPIO_1_3__I2C2_SDA		IOMUX_PAD(0x7D8, 0x3D0, (2 | IOMUX_CONFIG_SION), \
>  							0x9bc,   3, MX51_I2C_PAD_CTRL)
>  #define MX51_PAD_PMIC_INT_REQ__PMIC_INT_REQ	IOMUX_PAD(0x7FC, 0x3D4, 0, 0x0,   0, NO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_4__GPIO_1_4		IOMUX_PAD(0x804, 0x3D8, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_5__GPIO_1_5		IOMUX_PAD(0x808, 0x3DC, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_6__GPIO_1_6		IOMUX_PAD(0x80C, 0x3E0, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_7__GPIO_1_7		IOMUX_PAD(0x810, 0x3E4, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_8__GPIO_1_8		IOMUX_PAD(0x814, 0x3E8, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> -#define MX51_PAD_GPIO_1_9__GPIO_1_9		IOMUX_PAD(0x818, 0x3EC, 1, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_4__GPIO_1_4		IOMUX_PAD(0x804, 0x3D8, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_5__GPIO_1_5		IOMUX_PAD(0x808, 0x3DC, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_6__GPIO_1_6		IOMUX_PAD(0x80C, 0x3E0, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_7__GPIO_1_7		IOMUX_PAD(0x810, 0x3E4, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_8__GPIO_1_8		IOMUX_PAD(0x814, 0x3E8, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
> +#define MX51_PAD_GPIO_1_9__GPIO_1_9		IOMUX_PAD(0x818, 0x3EC, 0, 0x0,   0, MX51_GPIO_PAD_CTRL)
Before b545d9ed1b92f169d0326afac091328be5e76620 the muxmode entries were
correct.  Back when I looked at the patch that resulted into b545d9ed1b9
I wondered if the intended change was only
s/NO_PAD_CTRL/MX51_GPIO_PAD_CTRL/ but didn't check the reference manual.

Eric?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
