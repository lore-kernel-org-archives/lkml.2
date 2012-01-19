Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2ASIVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:21:48 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:53667 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2ASIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:21:43 -0500
Message-ID: <4F17D28E.1040801@atmel.com>
Date: Thu, 19 Jan 2012 09:21:34 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmatest: fix merge error resulting in incorrect count
 handling
References: <1326932515-7293-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1326932515-7293-1-git-send-email-paul.gortmaker@windriver.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 01:21 AM, Paul Gortmaker :
> We currently see this warning:
> 
>   drivers/dma/dmatest.c: In function ‘dmatest_add_channel’:
>   drivers/dma/dmatest.c:602:28: warning: the omitted middle operand
>    in ?: will always be ‘true’, suggest explicit middle operand [-Wparentheses]
> 
> It happens because commit f1aef8b6e6abf32a3a269542f95a19e2cb319f6c
> 
>   "dmaengine: dmatest: correct thread_count while using multiple thread per channel"
> 
> fixed the only two instances of this issue in the code, but then the
> commit 58691d64c44ae41ddf098ecb31e9a994026e3cff "dmatest: add pq support"
> was based on the old (unfixed) code, and so it reintroduced an instance
> of this error.  Using git describe, the baseline delta is apparent:
> 
> 	dmatest: correct thread_count	v2.6.30-8-gf1aef8b
> 	dmatest: add pq support		v2.6.29-rc8-80-g58691d6
> 
> Inspection of f1aef8b and/or the surrounding code leads one to the
> obvious fix.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Vinod Koul <vinod.koul@intel.com>
> 
> ---
> 
> [After creating this patch, I noticed it came up before in the
>  lkml archives, but a fix never got applied.  At least now the
>  real root cause is documented in this commit log.]
> 
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 2b8661b..24225f0 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -599,7 +599,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
>  	}
>  	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
>  		cnt = dmatest_add_threads(dtc, DMA_PQ);
> -		thread_count += cnt > 0 ?: 0;
> +		thread_count += cnt > 0 ? cnt : 0;
>  	}
>  
>  	pr_info("dmatest: Started %u threads using %s\n",


-- 
Nicolas Ferre
