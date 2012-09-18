Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2IRDk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:40:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:30749 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab2IRDkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:40:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,439,1344236400"; 
   d="scan'208";a="193913359"
Subject: Re: [PATCH 2/2] DMA: PL330: Check the pointer returned by kzalloc
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com, patches@linaro.org
In-Reply-To: <1347875423-7970-2-git-send-email-sachin.kamat@linaro.org>
References: <1347875423-7970-1-git-send-email-sachin.kamat@linaro.org>
	 <1347875423-7970-2-git-send-email-sachin.kamat@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 09:06:14 +0530
Message-ID: <1347939374.1943.172.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 15:20 +0530, Sachin Kamat wrote:
> kzalloc could return NULL. Hence add a check to avoid
> NULL pointer dereference.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/dma/pl330.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 018a445..5d3bbcd 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2930,6 +2930,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  		num_chan = max_t(int, pi->pcfg.num_peri, pi->pcfg.num_chan);
>  
>  	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
> +	if (!pdmac->peripherals) {
> +		ret = -ENOMEM;
> +		dev_err(&adev->dev, "unable to allocate pdmac->peripherals\n");
> +		goto probe_err5;
> +	}
>  
>  	for (i = 0; i < num_chan; i++) {
>  		pch = &pdmac->peripherals[i];

Thanks applied both to fixes. 
I have cc'ed stable as well

-- 
~Vinod

