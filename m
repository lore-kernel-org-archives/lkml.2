Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768634Ab2KOSFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:05:18 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:7416 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768597Ab2KOSFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:05:16 -0500
Message-ID: <1353002712.2532.42.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] powerpc: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: benh@kernel.crashing.org, m.szyprowski@samsung.com
Cc: kyungmin.park@samsung.com, paulus@samba.org, david@gibson.dropbear.id.au,
        arnd@arndb.de, andrzej.p@samsung.com, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 11:05:12 -0700
In-Reply-To: <1351267705.4013.18.camel@lorien2>
References: <1351210584.6851.21.camel@lorien2>
	 <1351267705.4013.18.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:08 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/powerpc/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
> index 7816087..e27e9ad 100644
> --- a/arch/powerpc/include/asm/dma-mapping.h
> +++ b/arch/powerpc/include/asm/dma-mapping.h
> @@ -172,6 +172,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
>  	struct dma_map_ops *dma_ops = get_dma_ops(dev);
>  
> +	debug_dma_mapping_error(dev, dma_addr);
>  	if (dma_ops->mapping_error)
>  		return dma_ops->mapping_error(dev, dma_addr);
>  

Marek,

This one is for powerpc to go through your tree with the other arch
debug_dma_mapping_error() patches.

Thanks,
-- Shuah

