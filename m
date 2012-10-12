Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab2JLPIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:08:53 -0400
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:49581 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754867Ab2JLPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:08:51 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Oct 2012 11:08:51 EDT
Date: Fri, 12 Oct 2012 16:48:37 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: vinod.koul@intel.com, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH V2 3/3] ARM: SPEAr13xx: Pass DW DMAC platform data from
 DT
Message-ID: <20121012144837.GE12801@game.jcrosoft.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
 <2039bc164224b0068bc078b6cd8df6218e754fce.1350051925.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2039bc164224b0068bc078b6cd8df6218e754fce.1350051925.git.viresh.kumar@linaro.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3339700599402703643
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  /* others */
> -#define DMAC0_BASE				UL(0xEA800000)
> -#define DMAC1_BASE				UL(0xEB000000)
>  #define MCIF_CF_BASE				UL(0xB2800000)
>  
>  /* Devices present in SPEAr1310 */
> diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
> index 9fbbfc5..0e60195 100644
> --- a/arch/arm/mach-spear13xx/spear1310.c
> +++ b/arch/arm/mach-spear13xx/spear1310.c
> @@ -36,9 +36,7 @@ static struct pl022_ssp_controller ssp1_plat_data = {
>  
>  /* Add SPEAr1310 auxdata to pass platform data */
>  static struct of_dev_auxdata spear1310_auxdata_lookup[] __initdata = {
> -	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_dma_priv),
> -	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC0_BASE, NULL, &dmac_plat_data),
> -	OF_DEV_AUXDATA("snps,dma-spear1340", DMAC1_BASE, NULL, &dmac_plat_data),
> +	OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, "cf"),
?/
>  	OF_DEV_AUXDATA("arm,pl022", SSP_BASE, NULL, &pl022_plat_data),
>  
>  	OF_DEV_AUXDATA("arm,pl022", SPEAR1310_SSP1_BASE, NULL, &ssp1_plat_data),
> diff --git a/arch/arm/mach-spear13xx/spear1340.c b/arch/arm/mach-spear13xx/spear1340.c
> index 081014f..7301f14 100644
> --- a/arch/arm/mach-spear13xx/spear1340.c
> +++ b/arch/arm/mach-spear13xx/spear1340.c
> @@ -20,7 +20,6 @@
>  #include <linux/of_platform.h>
>  #include <asm/hardware/gic.h>
>  #include <asm/mach/arch.h>
> -#include <mach/dma.h>
>  #include <mach/generic.h>
>  #include <mach/spear.h>
>  
> @@ -78,26 +77,10 @@
>  			(SPEAR1340_MIPHY_OSC_BYPASS_EXT | \
>  			SPEAR1340_MIPHY_PLL_RATIO_TOP(25))
>  

Best Regards,
J.
