Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2AZP6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:58:22 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:17332 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2AZP6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:58:21 -0500
Message-ID: <4F21780F.7060504@atmel.com>
Date: Thu, 26 Jan 2012 16:58:07 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dmaengine: dmatest: fix thread_count
References: <1327592025-2461-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1327592025-2461-1-git-send-email-danny.kukawka@bisect.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 04:33 PM, Danny Kukawka :
> It seems with commit f1aef8b6e6abf32a3a269542f95a19e2cb319f6c
> another case where thread_count wasn't calculated correctly
> has been overlooked.
> 
> This fix also a -Wparentheses compiler warning.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/dma/dmatest.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
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
