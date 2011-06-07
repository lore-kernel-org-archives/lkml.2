Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1FGOpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:45:46 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:65458 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756212Ab1FGOpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:45:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bIUzxZu2ZzB08hK0jFhT8
Date: Tue, 7 Jun 2011 17:45:35 +0300
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 03/12] OMAP3: Move common pmic configuration to
 pmic-common
Message-ID: <20110607144534.GA27477@atomide.com>
References: <1307456297-15010-1-git-send-email-peter.ujfalusi@ti.com>
 <1307456297-15010-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307456297-15010-4-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [110607 17:14]:
> Reduce the amount of duplicated code by moving the common
> configuration for twl4030/5030/tpsxx to the pmic-common file.
> Use the omap3_pmic_config function from board files to
> properly configure the PMIC with the common fields.
...

> --- a/arch/arm/mach-omap2/pmic-common.h
> +++ b/arch/arm/mach-omap2/pmic-common.h
> @@ -2,6 +2,9 @@
>  #define __OMAP_PMIC_COMMON__
>  
>  #define TWL_COMMON_PDATA_USB		(1 << 0)
> +#define TWL_COMMON_PDATA_BCI		(1 << 1)
> +#define TWL_COMMON_PDATA_MADC		(1 << 2)
> +#define TWL_COMMON_PDATA_CODEC		(1 << 3)

This is looking good, thanks for cleaning up the twl bloat in
board-*.c files :)

Maybe already define TWL_COMMON_PDATA_AUDIO here so you can
drop most of patch 7/12?

If you need both then you can temporarily have:

#define TWL_COMMON_PDATA_CODEC	TWL_COMMON_PDATA_AUDIO

Regards,

Tony
