Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab0LWHEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 02:04:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:20612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab0LWHED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 02:04:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,218,1291622400"; 
   d="scan'208";a="639663524"
From: "Yuan, Hang" <hang.yuan@intel.com>
To: Pierre Tardy <tardyp@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Gao, Yunpeng" <yunpeng.gao@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Date: Thu, 23 Dec 2010 15:02:48 +0800
Subject: RE: [RFC] sdhci: use ios->clock to know when sdhci is idle
Thread-Topic: [RFC] sdhci: use ios->clock to know when sdhci is idle
Thread-Index: Acuh2w9TBRtG1GR7SpW4rMcEgSPlvgAjKG6w
Message-ID: <41EFD7A46E18724CAB128DAD00733480193D2AE61C@shsmsx502.ccr.corp.intel.com>
References: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
In-Reply-To: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {E2F03DFC-28E3-471F-9CAD-BD848D90A170}
x-cr-hashedpuzzle: Zo5h aX/B h4rf jRYn mXfp uxPd 8aP9 9ybm ABoWPw== ADiXMQ==
 ADwXUA== AH4VAQ== AI/5aA== ALDGyw== AL8zdQ==
 AMfMYQ==;10;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAbABhAG4AQABsAGkAbgB1AHgALgBpAG4AdABlAGwALgBjAG8AbQA7AGMAagBiAEAAbABhAHAAdABvAHAALgBvAHIAZwA7AGwAaQBuAHUAcwAuAHcAYQBsAGwAZQBpAGoAQABzAHQAZQByAGkAYwBzAHMAbwBuAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AbQBtAGMAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AYQB4AGkAbQBsAGUAdgBpAHQAcwBrAHkAQABnAG0AYQBpAGwALgBjAG8AbQA7AG8AaABhAGQAQAB3AGkAegBlAHIAeQAuAGMAbwBtADsAdABhAHIAZAB5AHAAQABnAG0AYQBpAGwALgBjAG8AbQA7AHQAaQB3AGEAaQBAAHMAdQBzAGUALgBkAGUA;Sosha1_v1;7;{E2F03DFC-28E3-471F-9CAD-BD848D90A170};aABhAG4AZwAuAHkAdQBhAG4AQABpAG4AdABlAGwALgBjAG8AbQA=;Thu,
 23 Dec 2010 07:02:48
 GMT;UgBFADoAIABbAFIARgBDAF0AIABzAGQAaABjAGkAOgAgAHUAcwBlACAAaQBvAHMALQA+AGMAbABvAGMAawAgAHQAbwAgAGsAbgBvAHcAIAB3AGgAZQBuACAAcwBkAGgAYwBpACAAaQBzACAAaQBkAGwAZQA=
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just have a question why not let sdio card driver call pm_runtime_get/put instead of host
controller driver itself?
This patch may suspend host controller without cooperation of sdio card driver. But suspending
host controller will change controller's registers and then impact sdio card. I think it's
safer to suspend host controller according to sdio card driver's notification following runtime
PM framework. 

Another question is why to call pm_runtime_get/put when ios-clock changes? Is it based on
Linus Walleij's aggressive clock gating framework patch? Linus' patch doesn't gate SDIO cards.

Thanks,
Henry

> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-owner@vger.kernel.org]
> On Behalf Of Pierre Tardy
> Sent: Wednesday, December 22, 2010 9:14 PM
> To: linux-mmc@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Pierre Tardy; Chris Ball; Andrew Morton; Alan Cox; Takashi Iwai; Maxim Levitsky;
> Linus Walleij; Ohad Ben-Cohen; Gao, Yunpeng
> Subject: [RFC] sdhci: use ios->clock to know when sdhci is idle
> 
> This allows sdhci to detect its own activity and to autosuspend
> when not used
> 
> inspired from  mmci: handle clock frequency 0 properly
> From Linus Walleij <linus.walleij@stericsson.com>
> author of mmc aggressive clock gating fw.
> 
> The idea of using mmc clock gating fw in order to power gate the
> sdhci is simple (hope no too simplistic):
> Whenever the mmc fw tells we dont need the MMC clock, we dont need
> the sdhci power as well.
> 
> This does not mean that the child (card) is
> suspended. In case of a Wifi SDIO card, the card will be suspended
> and resumed according to the ifconfig up/down status.
> Even if the Wifi interface is up, user might not use the network.
> Sdhci can be powered off during those period. It is up to the HW
> implementation to implement smart enough power gating to still
> support enough always-on circuitry allowing to detect sdio
> interrupts.
> 
> This patch goes on top of Yunpeng's patch available on patchwork:
> 378052 [v2,2/3] mmc: enable runtime PM support of sdhci host controller
> 
> CC: Chris Ball <cjb@laptop.org>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alan Cox <alan@linux.intel.com>
> CC: Takashi Iwai <tiwai@suse.de>
> CC: Maxim Levitsky <maximlevitsky@gmail.com>
> CC: Linus Walleij <linus.walleij@stericsson.com>
> CC: Ohad Ben-Cohen <ohad@wizery.com>
> CC: Yunpeng Gao <yunpeng.gao@intel.com>
> 
> Signed-off-by: Pierre Tardy <tardyp@gmail.com>
> ---
>  drivers/mmc/host/sdhci.c  |   20 ++++++++++++++++++++
>  include/linux/mmc/sdhci.h |    1 +
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index a298fb0..a648330 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1161,6 +1161,7 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct
> mmc_ios *ios)
>  {
>  	struct sdhci_host *host;
>  	unsigned long flags;
> +        unsigned int lastclock;
>  	u8 ctrl;
> 
>  	host = mmc_priv(mmc);
> @@ -1171,6 +1172,24 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct
> mmc_ios *ios)
>  		goto out;
> 
>  	/*
> +	 * get/put runtime_pm usage counter at ios->clock transitions
> +         * We need to do it before any other chip access, as sdhci could
> +         * be power gated
> +	 */
> +        lastclock = host->iosclock;
> +        host->iosclock = ios->clock;
> +	if (lastclock == 0 && ios->clock != 0) {
> +		spin_unlock_irqrestore(&host->lock, flags);
> +		pm_runtime_get_sync(&host->parent.dev);
> +		spin_lock_irqsave(&host->lock, flags);
> +	} else if (lastclock != 0 && ios->clock == 0) {
> +		spin_unlock_irqrestore(&host->lock, flags);
> +		pm_runtime_put_autosuspend(&host->parent.dev);
> +		spin_lock_irqsave(&host->lock, flags);
> +		/* no need to configure the rest.. */
> +		goto out;
> +	}
> +	/*
>  	 * Reset the chip on each power off.
>  	 * Should clear out any weird states.
>  	 */
> @@ -1779,6 +1798,7 @@ struct sdhci_host *sdhci_alloc_host(struct device *dev,
> 
>  	host = mmc_priv(mmc);
>  	host->mmc = mmc;
> +	host->iosclock = 0;
> 
>  	return host;
>  }
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index 0d953f5..78c1528 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -114,6 +114,7 @@ struct sdhci_host {
>  	unsigned int timeout_clk;	/* Timeout freq (KHz) */
> 
>  	unsigned int clock;	/* Current clock (MHz) */
> +	unsigned int iosclock;	/* Last clock asked via set_ios  */
>  	u8 pwr;			/* Current voltage */
> 
>  	struct mmc_request *mrq;	/* Current request */
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
