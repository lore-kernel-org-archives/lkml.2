Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0HTQ0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:26:07 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:55533 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0HTQ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:26:05 -0400
Date: Fri, 20 Aug 2010 19:25:58 +0300 (EEST)
Message-Id: <20100820.192558.246512790.Hiroshi.DOYU@nokia.com>
To: h-kanigeri2@ti.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap:iommu-load cam register before flushing the entry
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <1282312218-26545-1-git-send-email-h-kanigeri2@ti.com>
References: <1282312218-26545-1-git-send-email-h-kanigeri2@ti.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hari,

From: ext Hari Kanigeri <h-kanigeri2@ti.com>
Subject: [PATCH] omap:iommu-load cam register before flushing the entry
Date: Fri, 20 Aug 2010 15:50:18 +0200

> The flush_iotlb_page is not loading the cam register before flushing
> the cam entry. This causes wrong entry to be flushed out from the TLB, and
> if the entry happens to be a locked TLB entry it would lead to MMU faults.
> 
> The fix is to load the cam register with the address to be flushed before
> flushing the TLB entry.
> 
> Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>

Ok for me. Thanks.

> ---
>  arch/arm/plat-omap/iommu.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
> index 2e603fe..c534280 100644
> --- a/arch/arm/plat-omap/iommu.c
> +++ b/arch/arm/plat-omap/iommu.c
> @@ -315,6 +315,7 @@ void flush_iotlb_page(struct iommu *obj, u32 da)
>  		if ((start <= da) && (da < start + bytes)) {
>  			dev_dbg(obj->dev, "%s: %08x<=%08x(%x)\n",
>  				__func__, start, da, bytes);
> +			iotlb_load_cr(obj, &cr);
>  			iommu_write_reg(obj, 1, MMU_FLUSH_ENTRY);
>  		}
>  	}
> -- 
> 1.7.0
> 
