Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1DFJP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:15:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:37198 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab1DFJPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:15:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,309,1299484800"; 
   d="scan'208";a="414656332"
Subject: Re: [PATCH] drivers, pch_dma: Fix uninitialized var before use
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        open list <linux-kernel@vger.kernel.org>
In-Reply-To: <1301725248-5102-1-git-send-email-namei.unix@gmail.com>
References: <1301725248-5102-1-git-send-email-namei.unix@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 14:15:13 +0530
Message-ID: <1302079513.18522.30.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-02 at 14:20 +0800, Liu Yuan wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> In the function pdc_desc_get(), var 'i' is not
> initialized before use. This patch fixes it.
> 
> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
> ---
>  drivers/dma/pch_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 8d8fef1..6eebc62 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -403,7 +403,7 @@ static struct pch_dma_desc *pdc_desc_get(struct pch_dma_chan *pd_chan)
>  {
>  	struct pch_dma_desc *desc, *_d;
>  	struct pch_dma_desc *ret = NULL;
> -	int i;
> +	int i = 0;
>  
>  	spin_lock(&pd_chan->lock);
>  	list_for_each_entry_safe(desc, _d, &pd_chan->free_list, desc_node) {
Applied, Thanks

-- 
~Vinod

