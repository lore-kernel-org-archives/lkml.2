Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab2KBQoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:44:22 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:32107 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab2KBQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:44:19 -0400
Message-ID: <1351874655.2721.16.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] c6x: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: msalter@redhat.com, Andrew Morton <akpm@linux-foundation.org>
Cc: a-jacquiot@ti.com, linux-c6x-dev@linux-c6x.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 02 Nov 2012 10:44:15 -0600
In-Reply-To: <1351266055.4013.1.camel@lorien2>
References: <1351206082.6851.6.camel@lorien2>
	 <1351266055.4013.1.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 09:40 -0600, Shuah Khan wrote:
> Add support for debug_dma_mapping_error() call to avoid warning from
> debug_dma_unmap() interface when it checks for mapping error checked
> status. Without this patch, device driver failed to check map error
> warning is generated.
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> ---
>  arch/c6x/include/asm/dma-mapping.h |    1 +
>  1 file changed, 1 insertion(+)

Would you like to this patch go through c6x arch tree or linux-next?
Please let me know your preference.

-- Shuah
> 
> diff --git a/arch/c6x/include/asm/dma-mapping.h b/arch/c6x/include/asm/dma-mapping.h
> index 03579fd..3c69406 100644
> --- a/arch/c6x/include/asm/dma-mapping.h
> +++ b/arch/c6x/include/asm/dma-mapping.h
> @@ -32,6 +32,7 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
>   */
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
> +	debug_dma_mapping_error(dev, dma_addr);
>  	return dma_addr == ~0;
>  }
>  


