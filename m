Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0GZHEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 03:04:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58769 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab0GZHEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 03:04:13 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Alexander Shishkin <virtuoso@slind.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jul 2010 12:33:56 +0530
Subject: RE: [PATCH 5/7] omap3: move EMU peripheral addresses to a platform
 header
Thread-Topic: [PATCH 5/7] omap3: move EMU peripheral addresses to a platform
 header
Thread-Index: AcssHGZX/VyEwaqsQb+MjOKn5nbabQAdDSFA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C62556AD@dbde02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
 <1280077520-7538-6-git-send-email-virtuoso@slind.org>
In-Reply-To: <1280077520-7538-6-git-send-email-virtuoso@slind.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Shishkin [mailto:virtuoso@slind.org]
> Sent: Sunday, July 25, 2010 10:35 PM
> To: linux-arm-kernel@lists.infradead.org
> Cc: Alexander Shishkin; Tony Lindgren; Russell King; Paul Walmsley;
> Shilimkar, Santosh; Kevin Hilman; linux-omap@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 5/7] omap3: move EMU peripheral addresses to a platform
> header
> 
> These addresses are also needed for the OFF code to save/restore the
> contexts of the EMU peripherals correctly.
> 
> Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-omap2/emu.c            |   14 ++++----------
>  arch/arm/plat-omap/include/plat/io.h |   20 ++++++++++++++++++++
>  2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/emu.c b/arch/arm/mach-omap2/emu.c
> index 9c442e2..6b41745 100644
> --- a/arch/arm/mach-omap2/emu.c
> +++ b/arch/arm/mach-omap2/emu.c
> @@ -24,19 +24,13 @@
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Alexander Shishkin");
> 
> -/* Cortex CoreSight components within omap3xxx EMU */
> -#define ETM_BASE	(L4_EMU_34XX_PHYS + 0x10000)
> -#define DBG_BASE	(L4_EMU_34XX_PHYS + 0x11000)
> -#define ETB_BASE	(L4_EMU_34XX_PHYS + 0x1b000)
> -#define DAPCTL		(L4_EMU_34XX_PHYS + 0x1d000)
> -
>  static struct amba_device omap3_etb_device = {
>  	.dev		= {
>  		.init_name = "etb",
>  	},
>  	.res		= {
> -		.start	= ETB_BASE,
> -		.end	= ETB_BASE + SZ_4K - 1,
> +		.start	= OMAP34XX_ETB_PHYS,
> +		.end	= OMAP34XX_ETB_PHYS + OMAP34XX_ETB_SIZE - 1,
>  		.flags	= IORESOURCE_MEM,
>  	},
>  	.periphid	= 0x000bb907,
> @@ -47,8 +41,8 @@ static struct amba_device omap3_etm_device = {
>  		.init_name = "etm",
>  	},
>  	.res		= {
> -		.start	= ETM_BASE,
> -		.end	= ETM_BASE + SZ_4K - 1,
> +		.start	= OMAP34XX_ETM_PHYS,
> +		.end	= OMAP34XX_ETM_PHYS + OMAP34XX_ETM_SIZE - 1,
>  		.flags	= IORESOURCE_MEM,
>  	},
>  	.periphid	= 0x102bb921,
> diff --git a/arch/arm/plat-omap/include/plat/io.h b/arch/arm/plat-
> omap/include/plat/io.h
> index 128b549..81f736a 100644
> --- a/arch/arm/plat-omap/include/plat/io.h
> +++ b/arch/arm/plat-omap/include/plat/io.h
> @@ -185,6 +185,26 @@
> 
>  /* 3430 IVA - currently unmapped */
> 
> +#define OMAP34XX_DBG_OFFSET	(0x00011000)
> +#define OMAP34XX_DBG_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_DBG_OFFSET)
> +#define OMAP34XX_DBG_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_DBG_OFFSET)
> +#define OMAP34XX_DBG_SIZE	SZ_4K
> +
> +#define OMAP34XX_ETM_OFFSET	(0x00010000)
> +#define OMAP34XX_ETM_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_ETM_OFFSET)
> +#define OMAP34XX_ETM_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_ETM_OFFSET)
> +#define OMAP34XX_ETM_SIZE	SZ_4K
> +
> +#define OMAP34XX_ETB_OFFSET	(0x0001b000)
> +#define OMAP34XX_ETB_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_ETB_OFFSET)
> +#define OMAP34XX_ETB_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_ETB_OFFSET)
> +#define OMAP34XX_ETB_SIZE	SZ_4K
> +
> +#define OMAP34XX_DAP_OFFSET	(0x0001d000)
> +#define OMAP34XX_DAP_VIRT	(L4_EMU_34XX_VIRT + OMAP34XX_DAP_OFFSET)
> +#define OMAP34XX_DAP_PHYS	(L4_EMU_34XX_PHYS + OMAP34XX_DAP_OFFSET)
> +#define OMAP34XX_DAP_SIZE	SZ_4K
> +
Changes looks good to me. 
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
