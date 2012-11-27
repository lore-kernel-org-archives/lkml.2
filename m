Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2K0Sm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:42:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:44874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2K0Sm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:42:27 -0500
Message-ID: <50B50985.1010700@infradead.org>
Date: Tue, 27 Nov 2012 10:42:13 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] staging/fwserial: Fix build breakage when !CONFIG_BUG
References: <20121127011738.9ecd7971a7ea2e3d09a9450d@canb.auug.org.au>	 <50B3D767.70604@infradead.org> <1354000267.3284.4.camel@thor>
In-Reply-To: <1354000267.3284.4.camel@thor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 11:11 PM, Peter Hurley wrote:

> Use WARN() as intended.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>


Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/staging/fwserial/dma_fifo.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/fwserial/dma_fifo.c b/drivers/staging/fwserial/dma_fifo.c
> index 72aa053..5e84634 100644
> --- a/drivers/staging/fwserial/dma_fifo.c
> +++ b/drivers/staging/fwserial/dma_fifo.c
> @@ -33,10 +33,7 @@
>  
>  #define FAIL(fifo, condition, format...) ({				\
>  	fifo->corrupt = !!(condition);					\
> -	if (unlikely(fifo->corrupt)) {					\
> -		__WARN_printf(format);					\
> -	}								\
> -	unlikely(fifo->corrupt);					\
> +	WARN(fifo->corrupt, format);					\
>  })
>  
>  /*



-- 
~Randy
