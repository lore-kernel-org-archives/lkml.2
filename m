Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2KBQs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:48:26 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:2051 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2KBQsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:48:24 -0400
Message-ID: <1351874901.2721.18.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] hexagon: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: rkuo@codeaurora.org, Andrew Morton <akpm@linux-foundation.org>
Cc: arnd@arndb.de, kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        linas@codeaurora.org, linux-hexagon@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 02 Nov 2012 10:48:21 -0600
In-Reply-To: <1351266197.4013.3.camel@lorien2>
References: <1351206731.6851.10.camel@lorien2>
	 <1351266197.4013.3.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 09:43 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/hexagon/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)

Would you like se this patch go through arch tree or linux-next? Please
let me know your preference.

-- Shuah
> 
> diff --git a/arch/hexagon/include/asm/dma-mapping.h b/arch/hexagon/include/asm/dma-mapping.h
> index 85e9935..1957c4c 100644
> --- a/arch/hexagon/include/asm/dma-mapping.h
> +++ b/arch/hexagon/include/asm/dma-mapping.h
> @@ -65,6 +65,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
>  	struct dma_map_ops *dma_ops = get_dma_ops(dev);
>  
> +	debug_dma_mapping_error(dev, dma_addr);
>  	if (dma_ops->mapping_error)
>  		return dma_ops->mapping_error(dev, dma_addr);
>  


