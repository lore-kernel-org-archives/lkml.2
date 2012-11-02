Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab2KBP66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:58:58 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:11108 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2KBP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:58:56 -0400
Message-ID: <1351871933.2721.10.camel@lorien2>
Subject: Re: [PATCH linux-next] ARM64: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: tony@atomide.com, olof@lixom.net, santosh.shilimkar@ti.com,
        nico@linaro.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, shuahkhan@gmail.com
Date: Fri, 02 Nov 2012 09:58:53 -0600
In-Reply-To: <1351264983.2712.14.camel@lorien2>
References: <1351205220.6851.3.camel@lorien2>
	 <CAHkRjk6jDKsFMa1_Wapwr7y5n8Ut8xfNBKWniSfHN_01z7qWFQ@mail.gmail.com>
	 <1351264983.2712.14.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 09:23 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated. 
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Do you want this patch going through linux-next or the ARM64 tree? Let
me know your preference.

-- Shuah
> ---
>  arch/arm64/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/include/asm/dma-mapping.h b/arch/arm64/include/asm/dma-mapping.h
> index 538f4b4..9947768 100644
> --- a/arch/arm64/include/asm/dma-mapping.h
> +++ b/arch/arm64/include/asm/dma-mapping.h
> @@ -50,6 +50,7 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dev_addr)
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t dev_addr)
>  {
>  	struct dma_map_ops *ops = get_dma_ops(dev);
> +	debug_dma_mapping_error(dev, dev_addr);
>  	return ops->mapping_error(dev, dev_addr);
>  }
>  


