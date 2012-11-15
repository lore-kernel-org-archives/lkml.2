Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768619Ab2KORxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:53:17 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:16086 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768574Ab2KORws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:52:48 -0500
Message-ID: <1353001963.2532.33.camel@lorien2>
Subject: Re: [PATCH RFT linux-next] sh: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: lethal@linux-sh.org, m.szyprowski@samsung.com
Cc: kyungmin.park@samsung.com, arnd@arndb.de, andrzej.p@samsung.com,
        linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 10:52:43 -0700
In-Reply-To: <1351268403.4013.24.camel@lorien2>
References: <1351268403.4013.24.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:20 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/sh/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/sh/include/asm/dma-mapping.h b/arch/sh/include/asm/dma-mapping.h
> index 8bd965e..b437f2c 100644
> --- a/arch/sh/include/asm/dma-mapping.h
> +++ b/arch/sh/include/asm/dma-mapping.h
> @@ -46,6 +46,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
>  	struct dma_map_ops *ops = get_dma_ops(dev);
>  
> +	debug_dma_mapping_error(dev, dma_addr);
>  	if (ops->mapping_error)
>  		return ops->mapping_error(dev, dma_addr);
>  

Marek,

This one is for sh to go through tree with the other arch
dma_debug_dma_mapping_error() change patches.

Thanks,
-- Shuah

