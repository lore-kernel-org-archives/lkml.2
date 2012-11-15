Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768627Ab2KOSAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:00:40 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:22673 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768575Ab2KOSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:00:39 -0500
Message-ID: <1353002435.2532.39.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] openrisc: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: jonas@southpole.se, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux@openrisc.net, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 11:00:35 -0700
In-Reply-To: <1351267555.4013.15.camel@lorien2>
References: <1351208548.6851.19.camel@lorien2>
	 <1351267555.4013.15.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:05 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/openrisc/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
> index fab8628..f12de49 100644
> --- a/arch/openrisc/include/asm/dma-mapping.h
> +++ b/arch/openrisc/include/asm/dma-mapping.h
> @@ -95,6 +95,7 @@ static inline int dma_supported(struct device *dev, u64 dma_mask)
>  
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
> +	debug_dma_mapping_error(dev, dma_addr);
>  	return 0;
>  }
>  

Marek/Jonas,

This one is for openrisc to go through Marek's tree with the other arch
debug_dma_mapping_error() patches. Hoping it is ok with Jonas.

Thanks,
-- Shuah

