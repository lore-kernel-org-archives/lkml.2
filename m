Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab2JZOtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:49:15 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55949 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZOtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <1351205220.6851.3.camel@lorien2>
References: <1351205220.6851.3.camel@lorien2>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 26 Oct 2012 15:48:52 +0100
X-Google-Sender-Auth: 2szWHQbKRmeBDOv2Siblr6d4U2U
Message-ID: <CAHkRjk6jDKsFMa1_Wapwr7y5n8Ut8xfNBKWniSfHN_01z7qWFQ@mail.gmail.com>
Subject: Re: [PATCH RFT] ARM64: dma-mapping: support debug_dma_mapping_error
To: shuah.khan@hp.com
Cc: tony@atomide.com, olof@lixom.net, santosh.shilimkar@ti.com,
        nico@linaro.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, shuahkhan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 October 2012 23:47, Shuah Khan <shuah.khan@hp.com> wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
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
>         struct dma_map_ops *ops = get_dma_ops(dev);
> +       debug_dma_mapping_error(dev, dev_addr);
>         return ops->mapping_error(dev, dev_addr);
>  }

The patch looks fine but debug_dma_mapping_error() is not in mainline
yet, so it will have to wait. If you want to add it to your series
(which I assume adds debug_dma_mapping_error() support), you can add
my Acked-by on the patch.

-- 
Catalin
