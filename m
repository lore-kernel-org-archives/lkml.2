Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab2H0HDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:03:31 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:35753 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2H0HDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:03:30 -0400
Date: Mon, 27 Aug 2012 09:03:23 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
Message-ID: <20120827070323.GC28721@samfundet.no>
References: <503A8CAE.6050606@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503A8CAE.6050606@yahoo.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 27 Aug 2012 04:53:02 +0800 or thereabout, Hein Tibosch wrote:
> The dw_dmac was originally developed for avr32 to be used with the
> Synopsys DesignWare AHB DMA controller. After 2.6.38, device access was done
> with the little-endian readl/writel functions. This didn't work on the
> avr32 platform, because it needs native-endian (i.e. big-endian) accessors.
> This patch makes the endianness configurable using 'DW_DMAC_BE',
> which will default be true for AVR32

I think the English in kconfig could use some brushing up.

> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
> ---
>  drivers/dma/Kconfig        |    8 ++++++++
>  drivers/dma/dw_dmac_regs.h |   23 +++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index aadeb5b..3635daf 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -89,6 +89,14 @@ config DW_DMAC
>  	  Support the Synopsys DesignWare AHB DMA controller.  This
>  	  can be integrated in chips such as the Atmel AT32ap7000.
>  
> +config DW_DMAC_BE
>

This name isn't that long, so we could skip the abbreviation of big endian;
DW_DMAC_BIG_ENDIAN_IO or something similar?

> +	bool "Synopsys DesignWare AHB DMA needs big endian access"
>

bool "Use big endian I/O register access"

> +	default y if AVR32
> +	depends on DW_DMAC
> +	help
> +	  Say yes if access to the Synopsys DesignWare AHB DMA controller
> +	  should be big endian, such as for Atmel AT32ap7000
> +

"Say yes here to use big endian I/O access when reading and writing to the
DMA controller registers. This is needed on some platforms, like the Atmel
AVR32 architecture.

If unsure, use the default setting."

<snipp patch diff>

-- 
mvh
Hans-Christian Egtvedt
