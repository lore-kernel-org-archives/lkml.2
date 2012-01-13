Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab2AMNY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:24:56 -0500
Received: from smtp.nokia.com ([147.243.1.47]:47897 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab2AMNYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:24:55 -0500
Date: Fri, 13 Jan 2012 15:22:12 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@kernel.research.nokia.com
To: Dmitry Antipov <dmitry.antipov@linaro.org>
cc: linaro-dev@lists.linaro.org, patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: use usleep_range() in mmc_delay()
In-Reply-To: <4EF18310.6080801@linaro.org>
Message-ID: <alpine.DEB.2.00.1201131514490.31704@kernel.research.nokia.com>
References: <4EF18310.6080801@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 21 Dec 2011, Dmitry Antipov wrote:
> From f447d78db65c6675e69466e8ed08364ff065ac08 Mon Sep 17 00:00:00 2001
> From: Dmitry Antipov <dmitry.antipov@linaro.org>
> Date: Wed, 21 Dec 2011 10:51:03 +0400
> Subject: [PATCH] mmc: use usleep_range() in mmc_delay()
>
> ---

Shouldn't you add a proper patch description and a signed-off-by line?

> drivers/mmc/core/core.h |    8 ++------
> 1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
> index 14664f1..a77851e 100644
> --- a/drivers/mmc/core/core.h
> +++ b/drivers/mmc/core/core.h
> @@ -47,12 +47,8 @@ void mmc_power_off(struct mmc_host *host);
>
> static inline void mmc_delay(unsigned int ms)
> {
> -	if (ms < 1000 / HZ) {
> -		cond_resched();
> -		mdelay(ms);
> -	} else {
> -		msleep(ms);
> -	}
> +	unsigned long us = ms * USEC_PER_MSEC;
> +	usleep_range(us, us + 1000);
> }

Anyway, I think the change is good. On systems with multiple MMC devices
the boot/probe can spend 100-200 ms alone just doing busylooping delays. I
think e.g. in mmc_rescan() the code uses frequently mmc_delay(10).

> void mmc_rescan(struct work_struct *work);
> -- 
> 1.7.7.4

A.
