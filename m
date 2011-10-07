Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861Ab1JGFF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 01:05:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:37254 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab1JGFFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 01:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="59995500"
Subject: Re: [patch] dma/timberdale: free_irq() on an error path
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20110923061601.GB4387@elgon.mountain>
References: <20110923061601.GB4387@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 10:28:45 +0530
Message-ID: <1317963525.1573.2227.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 09:16 +0300, Dan Carpenter wrote:
> There was an error path that skipped the free_irq() step by mistake.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
> index 6dbdf45..a4a398f 100644
> --- a/drivers/dma/timb_dma.c
> +++ b/drivers/dma/timb_dma.c
> @@ -762,7 +762,7 @@ static int __devinit td_probe(struct platform_device *pdev)
>  		if ((i % 2) == pchan->rx) {
>  			dev_err(&pdev->dev, "Wrong channel configuration\n");
>  			err = -EINVAL;
> -			goto err_tasklet_kill;
> +			goto err_free_irq;
>  		}
>  
>  		td_chan->chan.device = &td->dma;
Applied thanks

-- 
~Vinod

