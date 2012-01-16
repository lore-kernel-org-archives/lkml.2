Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2APNL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:11:58 -0500
Received: from smtp.nokia.com ([147.243.128.26]:50875 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab2APNL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:11:57 -0500
From: <ext-denis.2.karpov@nokia.com>
To: <shubhrajyoti@ti.com>, <linux-mmc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC] mmc : omap_hsmmc : Save and restore the sysc across
 reset
Thread-Topic: [PATCH RFC] mmc : omap_hsmmc : Save and restore the sysc
 across reset
Thread-Index: AQHM1EL/mf6ola8WEkW6K3MWR6zOfpYO8jXg
Date: Mon, 16 Jan 2012 13:11:46 +0000
Message-ID: <5E7C2FE2AE03DF4CA6AC500032BF8F77C1762A@008-AM1MPN1-072.mgdnok.nokia.com>
References: <1326713587-26463-1-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1326713587-26463-1-git-send-email-shubhrajyoti@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.50.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jan 2012 13:11:48.0652 (UTC) FILETIME=[678ABEC0:01CCD450]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Shubhrajyoti D wrote on 2012-01-16:
> The commit 11dd62:[omap_hsmmc: context save/restore support]
> 
> does a reset and restores AUTOIDLE settings.
> This patch saves the register does a reset and restores
> the same configuration.
...
>  	if (pdata->get_context_loss_count) {
> @@ -700,6 +700,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host
> *host)
>  		&& time_before(jiffies, timeout))
>  		;
> +	sysc = OMAP_HSMMC_READ(host->base, SYSCONFIG);
>  	/* Do software reset */
>  	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, SOFTRESET);
>  	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
> @@ -707,8 +708,7 @@ static int omap_hsmmc_context_restore(struct omap_hsmmc_host
> *host)
>  		&& time_before(jiffies, timeout))
>  		;
> -	OMAP_HSMMC_WRITE(host->base, SYSCONFIG,
> -			OMAP_HSMMC_READ(host->base, SYSCONFIG) | AUTOIDLE);
> +	OMAP_HSMMC_WRITE(host->base, SYSCONFIG, sysc);

The meaning of the code is to restore the register context after it was lost during transition into low power consumption state. SW reset is needed to bring all the registers in a consistent state before reconfiguring some of them. 

Saving and restoring the SYSCONFIG register across SW reset is not needed. 

Also re-configuring AUTOIDLE feature is not necessary since SYSCONFIG reset value has is 1 already, according to TRM. I guess it was done to make things more explicit.

Denis
