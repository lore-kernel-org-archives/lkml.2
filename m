Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1GYO0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 10:26:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42895 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1GYO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 10:26:15 -0400
Subject: Re: [PATCH] dma: intel_mid_dma: remove redundant pci_set_drvdata
 calls
From: Vinod Koul <vkoul@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        Yong Wang <yong.y.wang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1311058097.2873.2.camel@phoenix>
References: <1311058097.2873.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corp
Date: Mon, 25 Jul 2011 19:55:08 +0530
Message-ID: <1311603908.8206.17.camel@vkoul-mobl4>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 14:48 +0800, Axel Lin wrote:
> Call pci_set_drvdata() once in intel_mid_dma_probe() is enough.
> Remove redundant pci_set_drvdata() calls in dma_suspend() and dma_resume().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/dma/intel_mid_dma.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
> index f653517..8a3fdd8 100644
> --- a/drivers/dma/intel_mid_dma.c
> +++ b/drivers/dma/intel_mid_dma.c
> @@ -1351,7 +1351,6 @@ int dma_suspend(struct pci_dev *pci, pm_message_t state)
>  			return -EAGAIN;
>  	}
>  	device->state = SUSPENDED;
> -	pci_set_drvdata(pci, device);
>  	pci_save_state(pci);
>  	pci_disable_device(pci);
>  	pci_set_power_state(pci, PCI_D3hot);
> @@ -1380,7 +1379,6 @@ int dma_resume(struct pci_dev *pci)
>  	}
>  	device->state = RUNNING;
>  	iowrite32(REG_BIT0, device->dma_base + DMA_CFG);
> -	pci_set_drvdata(pci, device);
>  	return 0;
>  }
>  
Applied, Thanks

-- 
~Vinod Koul
Intel Corp.

