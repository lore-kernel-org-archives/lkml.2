Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768588Ab2KORte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:49:34 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30599 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768567Ab2KORtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:49:33 -0500
Message-ID: <1353001768.2532.31.camel@lorien2>
Subject: Re: [PATCH RFT linux-next] alpha: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: rth@twiddle.net, m.szyprowski@samsung.com
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, kyungmin.park@samsung.com,
        arnd@arndb.de, andrzej.p@samsung.com, linux-alpha@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 10:49:28 -0700
In-Reply-To: <1351269163.4013.27.camel@lorien2>
References: <1351269163.4013.27.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 10:32 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/alpha/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> index dfa32f0..b4d483b 100644
> --- a/arch/alpha/include/asm/dma-mapping.h
> +++ b/arch/alpha/include/asm/dma-mapping.h
> @@ -32,6 +32,7 @@ static inline void dma_free_attrs(struct device *dev, size_t size,
>  
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
> +	debug_dma_mapping_error(dev, dma_addr);
>  	return get_dma_ops(dev)->mapping_error(dev, dma_addr);
>  }
>  

Marek,

This is for alpha to go through your tree.

-- Shuah


