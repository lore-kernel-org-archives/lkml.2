Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768648Ab2KOSIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:08:51 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:9004 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768597Ab2KOSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:08:50 -0500
Message-ID: <1353002927.2532.46.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] ia64: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: tony.luck@intel.com, m.szyprowski@samsung.com
Cc: fenghua.yu@intel.com, arnd@arndb.de, andrzej.p@samsung.com,
        kyungmin.park@samsung.com, linux-ia64@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 11:08:47 -0700
In-Reply-To: <1351266308.4013.5.camel@lorien2>
References: <1351207286.6851.13.camel@lorien2>
	 <1351266308.4013.5.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 09:45 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/ia64/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
> index 4f5e814..cf3ab7e 100644
> --- a/arch/ia64/include/asm/dma-mapping.h
> +++ b/arch/ia64/include/asm/dma-mapping.h
> @@ -58,6 +58,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t daddr)
>  {
>  	struct dma_map_ops *ops = platform_dma_get_ops(dev);
> +	debug_dma_mapping_error(dev, daddr);
>  	return ops->mapping_error(dev, daddr);
>  }
>  

Marek,

This one is for ia64 to go through your tree with all the other arch
debug_dma_mapping_error() patches.

Thanks,
-- Shuah

