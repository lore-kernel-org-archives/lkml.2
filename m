Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2ILHsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:48:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38442 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab2ILHsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:48:22 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "S, Venkatraman" <svenkatr@ti.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "cjb@laptop.org" <cjb@laptop.org>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
Subject: RE: [PATCH] mmc: omap_hsmmc: Enable HSPE bit for high speed cards
Thread-Topic: [PATCH] mmc: omap_hsmmc: Enable HSPE bit for high speed cards
Thread-Index: AQHNiqD9Is2lA8IYP0Sv6fHcSAOj0JeGXrNw
Date: Wed, 12 Sep 2012 07:48:13 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA7F8AE@DBDE01.ent.ti.com>
References: <1346764151-21323-1-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1346764151-21323-1-git-send-email-gururaja.hebbar@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {62F9217E-ED33-4898-825C-E45B419B2476}
x-cr-hashedpuzzle: AKCr A0mM GqMn MJ2Q RVk3 XKVB XhzZ b9P2 fJRE ucFq 0gBk
 7O3c 7sv3 +yMA AAS7Rg==
 ABdEAw==;6;YwBqAGIAQABsAGEAcAB0AG8AcAAuAG8AcgBnADsAZwByAGEAbgB0AC4AbABpAGsAZQBsAHkAQABzAGUAYwByAGUAdABsAGEAYgAuAGMAYQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBtAG0AYwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AbwBtAGEAcABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBvAGIALgBoAGUAcgByAGkAbgBnAEAAYwBhAGwAeABlAGQAYQAuAGMAbwBtAA==;Sosha1_v1;7;{62F9217E-ED33-4898-825C-E45B419B2476};ZwB1AHIAdQByAGEAagBhAC4AaABlAGIAYgBhAHIAQAB0AGkALgBjAG8AbQA=;Wed,
 12 Sep 2012 07:47:55
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAbQBtAGMAOgAgAG8AbQBhAHAAXwBoAHMAbQBtAGMAOgAgAEUAbgBhAGIAbABlACAASABTAFAARQAgAGIAaQB0ACAAZgBvAHIAIABoAGkAZwBoACAAcwBwAGUAZQBkACAAYwBhAHIAZABzAA==
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 18:39:11, Hebbar, Gururaja wrote:
> HSMMC IP on AM33xx need a special setting to handle High-speed cards.
> Other platforms like TI81xx, OMAP4 may need this as-well. This depends
> on the HSMMC IP timing closure done for the high speed cards.
> 
> From AM335x TRM (SPRUH73F - 18.3.12 Output Signals Generation)
> 
> The MMC/SD/SDIO output signals can be driven on either falling edge or
> rising edge depending on the SD_HCTL[2] HSPE bit. This feature allows
> to reach better timing performance, and thus to increase data transfer
> frequency.
> 
> There are few pre-requisites for enabling the HSPE bit
> - Controller should support High-Speed-Enable Bit and
> - Controller should not be using DDR Mode and
> - Controller should advertise that it supports High Speed in
>   capabilities register and
> - MMC/SD clock coming out of controller > 25MHz


Gentle Ping. Is there any update on this patch?. If not, can this be pulled in. 

> 
> Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
> ---
> :100644 100644 be76a23... ed271fc... M	Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> :100644 100644 eb3e4d5... 00c658b... M	arch/arm/plat-omap/include/plat/mmc.h
> :100644 100644 c3e96a2... 0e14834... M	drivers/mmc/host/omap_hsmmc.c
>  .../devicetree/bindings/mmc/ti-omap-hsmmc.txt      |    1 +
>  arch/arm/plat-omap/include/plat/mmc.h              |    1 +
>  drivers/mmc/host/omap_hsmmc.c                      |   30 +++++++++++++++++++-
>  3 files changed, 31 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> index be76a23..ed271fc 100644
> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
> @@ -19,6 +19,7 @@ ti,dual-volt: boolean, supports dual voltage cards
>  "supply-name" examples are "vmmc", "vmmc_aux" etc
>  ti,non-removable: non-removable slot (like eMMC)
>  ti,needs-special-reset: Requires a special softreset sequence
> +ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
>  
>  Example:
>  	mmc1: mmc@0x4809c000 {
> diff --git a/arch/arm/plat-omap/include/plat/mmc.h b/arch/arm/plat-omap/include/plat/mmc.h
> index eb3e4d5..00c658b 100644
> --- a/arch/arm/plat-omap/include/plat/mmc.h
> +++ b/arch/arm/plat-omap/include/plat/mmc.h
> @@ -127,6 +127,7 @@ struct omap_mmc_platform_data {
>  		/* we can put the features above into this variable */
>  #define HSMMC_HAS_PBIAS		(1 << 0)
>  #define HSMMC_HAS_UPDATED_RESET	(1 << 1)
> +#define HSMMC_HAS_HSPE_SUPPORT	(1 << 2)
>  		unsigned features;
>  
>  		int switch_pin;			/* gpio (card detect) */
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index c3e96a2..0e14834 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -63,6 +63,7 @@
>  
>  #define VS18			(1 << 26)
>  #define VS30			(1 << 25)
> +#define HSS			(1 << 21)
>  #define SDVS18			(0x5 << 9)
>  #define SDVS30			(0x6 << 9)
>  #define SDVS33			(0x7 << 9)
> @@ -90,6 +91,7 @@
>  #define MSBS			(1 << 5)
>  #define BCE			(1 << 1)
>  #define FOUR_BIT		(1 << 1)
> +#define HSPE			(1 << 2)
>  #define DDR			(1 << 19)
>  #define DW8			(1 << 5)
>  #define CC			0x1
> @@ -490,6 +492,7 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
>  	struct mmc_ios *ios = &host->mmc->ios;
>  	unsigned long regval;
>  	unsigned long timeout;
> +	unsigned long clkdiv;
>  
>  	dev_vdbg(mmc_dev(host->mmc), "Set clock to %uHz\n", ios->clock);
>  
> @@ -497,7 +500,8 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
>  
>  	regval = OMAP_HSMMC_READ(host->base, SYSCTL);
>  	regval = regval & ~(CLKD_MASK | DTO_MASK);
> -	regval = regval | (calc_divisor(host, ios) << 6) | (DTO << 16);
> +	clkdiv = calc_divisor(host, ios);
> +	regval = regval | (clkdiv << 6) | (DTO << 16);
>  	OMAP_HSMMC_WRITE(host->base, SYSCTL, regval);
>  	OMAP_HSMMC_WRITE(host->base, SYSCTL,
>  		OMAP_HSMMC_READ(host->base, SYSCTL) | ICE);
> @@ -508,6 +512,27 @@ static void omap_hsmmc_set_clock(struct omap_hsmmc_host *host)
>  		&& time_before(jiffies, timeout))
>  		cpu_relax();
>  
> +	/*
> +	 * Enable High-Speed Support
> +	 * Pre-Requisites
> +	 *	- Controller should support High-Speed-Enable Bit
> +	 *	- Controller should not be using DDR Mode
> +	 *	- Controller should advertise that it supports High Speed
> +	 *	  in capabilities register
> +	 *	- MMC/SD clock coming out of controller > 25MHz
> +	 */
> +	if ((mmc_slot(host).features & HSMMC_HAS_HSPE_SUPPORT) &&
> +	    (ios->timing != MMC_TIMING_UHS_DDR50) &&
> +	    ((OMAP_HSMMC_READ(host->base, CAPA) & HSS) == HSS)) {
> +		regval = OMAP_HSMMC_READ(host->base, HCTL);
> +		if (clkdiv && (clk_get_rate(host->fclk)/clkdiv) > 25000000)
> +			regval |= HSPE;
> +		else
> +			regval &= ~HSPE;
> +
> +		OMAP_HSMMC_WRITE(host->base, HCTL, regval);
> +	}
> +
>  	omap_hsmmc_start_clock(host);
>  }
>  
> @@ -1701,6 +1726,9 @@ static struct omap_mmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
>  	if (of_find_property(np, "ti,needs-special-reset", NULL))
>  		pdata->slots[0].features |= HSMMC_HAS_UPDATED_RESET;
>  
> +	if (of_find_property(np, "ti,needs-special-hs-handling", NULL))
> +		pdata->slots[0].features |= HSMMC_HAS_HSPE_SUPPORT;
> +
>  	return pdata;
>  }
>  #else
> -- 
> 1.7.1
> 
> 


Regards, 
Gururaja
