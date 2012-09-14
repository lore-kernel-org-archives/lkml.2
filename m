Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab2INDMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:12:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:17220 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab2INDMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:12:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="221875818"
Subject: Re: [PATCH] dma: tegra: use list_move_tail instead of
 list_del/list_add_tail
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: djbw@fb.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <CAPgLHd9DHDY9-oxFRK6coarc8JqKGporKSXTFG5fkRioZz6xFw@mail.gmail.com>
References: <CAPgLHd9DHDY9-oxFRK6coarc8JqKGporKSXTFG5fkRioZz6xFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:39:06 +0530
Message-ID: <1347592146.1943.14.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 15:08 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Applied thanks
> ---
>  drivers/dma/tegra20-apb-dma.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> index 24acd71..6ed3f43 100644
> --- a/drivers/dma/tegra20-apb-dma.c
> +++ b/drivers/dma/tegra20-apb-dma.c
> @@ -475,8 +475,7 @@ static void tegra_dma_abort_all(struct tegra_dma_channel *tdc)
>  	while (!list_empty(&tdc->pending_sg_req)) {
>  		sgreq = list_first_entry(&tdc->pending_sg_req,
>  						typeof(*sgreq), node);
> -		list_del(&sgreq->node);
> -		list_add_tail(&sgreq->node, &tdc->free_sg_req);
> +		list_move_tail(&sgreq->node, &tdc->free_sg_req);
>  		if (sgreq->last_sg) {
>  			dma_desc = sgreq->dma_desc;
>  			dma_desc->dma_status = DMA_ERROR;
> @@ -570,8 +569,7 @@ static void handle_cont_sngl_cycle_dma_done(struct tegra_dma_channel *tdc,
>  
>  	/* If not last req then put at end of pending list */
>  	if (!list_is_last(&sgreq->node, &tdc->pending_sg_req)) {
> -		list_del(&sgreq->node);
> -		list_add_tail(&sgreq->node, &tdc->pending_sg_req);
> +		list_move_tail(&sgreq->node, &tdc->pending_sg_req);
>  		sgreq->configured = false;
>  		st = handle_continuous_head_request(tdc, sgreq, to_terminate);
>  		if (!st)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

