Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab2GFNzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:55:22 -0400
Received: from 11.mo3.mail-out.ovh.net ([87.98.184.158]:45293 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751357Ab2GFNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:55:21 -0400
X-Greylist: delayed 7226 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 09:55:20 EDT
Date: Fri, 6 Jul 2012 13:28:34 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: jgq516@gmail.com
Cc: linux@arm.linux.org.uk, tony@atomide.com, nicolas.ferre@atmel.com,
        arnd@arndb.de, swarren@nvidia.com, olof@lixom.net,
        ldewangan@nvidia.com, hdoyu@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 1/1] ARM: add PROC_DEVICETREE support in Kconfig
Message-ID: <20120706112834.GA4450@game.jcrosoft.org>
References: <1341571127-14461-1-git-send-email-jgq516@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341571127-14461-1-git-send-email-jgq516@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 14682579211847117622
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegkedrieelucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegkedrieelucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:38 Fri 06 Jul     , jgq516@gmail.com wrote:
> From: Xiao Jiang <jgq516@gmail.com>
> 
> Since more and more arm chips support device tree, it'd be better add PROC_DEVICETREE
> in arch/arm/Kconfig to avoid duplicate code.
> 
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
> ---
>  arch/arm/Kconfig                   |    1 +
>  arch/arm/configs/at91_dt_defconfig |    1 -
>  arch/arm/configs/tegra_defconfig   |    1 -
>  arch/arm/plat-omap/Kconfig         |    1 -
>  4 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a91009c..f68896e 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1864,6 +1864,7 @@ config USE_OF
>  	select OF
>  	select OF_EARLY_FLATTREE
>  	select IRQ_DOMAIN
> +	select PROC_DEVICETREE if PROC_FS
>  	help
>  	  Include support for flattened device tree machine descriptions.
>  
> diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
> index 67bc571..b856cb6 100644
> --- a/arch/arm/configs/at91_dt_defconfig
> +++ b/arch/arm/configs/at91_dt_defconfig
> @@ -64,7 +64,6 @@ CONFIG_MTD_NAND=y
>  CONFIG_MTD_NAND_ATMEL=y
>  CONFIG_MTD_UBI=y
>  CONFIG_MTD_UBI_GLUEBI=y
> -CONFIG_PROC_DEVICETREE=y
>  CONFIG_BLK_DEV_LOOP=y
>  CONFIG_BLK_DEV_RAM=y
>  CONFIG_BLK_DEV_RAM_COUNT=4
> diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
> index 1198dd6..43e7b65 100644
> --- a/arch/arm/configs/tegra_defconfig
> +++ b/arch/arm/configs/tegra_defconfig
> @@ -72,7 +72,6 @@ CONFIG_IPV6_TUNNEL=y
>  CONFIG_IPV6_MULTIPLE_TABLES=y
>  # CONFIG_WIRELESS is not set
>  # CONFIG_FIRMWARE_IN_KERNEL is not set
> -CONFIG_PROC_DEVICETREE=y
>  CONFIG_BLK_DEV_LOOP=y
>  CONFIG_AD525X_DPOT=y
>  CONFIG_AD525X_DPOT_I2C=y
> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index ad95c7a..4e2cb17 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -27,7 +27,6 @@ config ARCH_OMAP2PLUS
>  	select GENERIC_IRQ_CHIP
>  	select OMAP_DM_TIMER
>  	select USE_OF
> -	select PROC_DEVICETREE if PROC_FS
>  	help
>  	  "Systems based on OMAP2, OMAP3 or OMAP4"
>  
> -- 
> 1.7.3
> 
