Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab2JXLTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:19:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:59126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2JXLTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:19:46 -0400
Subject: Re: [PATCH] pch_dma: use module_pci_driver to simplify the code
From: Vinod Koul <vkoul@infradead.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: vinod.koul@intel.com, djbw@fb.com, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAPgLHd9EpvEuFp4wtL+-BJRyd4t26qh9yzfbAvb5M+OPUttjCQ@mail.gmail.com>
References: <CAPgLHd9EpvEuFp4wtL+-BJRyd4t26qh9yzfbAvb5M+OPUttjCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 16:36:13 +0530
Message-ID: <1351076773.5263.59.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 21:04 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/dma/pch_dma.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 987ab5c..b405916 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -1029,18 +1029,7 @@ static struct pci_driver pch_dma_driver = {
>  #endif
>  };
>  
> -static int __init pch_dma_init(void)
> -{
> -	return pci_register_driver(&pch_dma_driver);
> -}
> -
> -static void __exit pch_dma_exit(void)
> -{
> -	pci_unregister_driver(&pch_dma_driver);
> -}
> -
> -module_init(pch_dma_init);
> -module_exit(pch_dma_exit);
> +module_pci_driver(pch_dma_driver);
>  
>  MODULE_DESCRIPTION("Intel EG20T PCH / LAPIS Semicon ML7213/ML7223/ML7831 IOH "
>  		   "DMA controller driver");
> 
> 
Applied thanks

-- 
Vinod Koul
Intel Corp.

