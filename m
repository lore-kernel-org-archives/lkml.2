Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2JPJRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:17:51 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:55409 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2JPJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:17:50 -0400
Date: Tue, 16 Oct 2012 11:17:40 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com,
        linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH] avr32: fix build error in atstk1006_defconfig
Message-ID: <20121016091740.GA6243@samfundet.no>
References: <1350371967-8914-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350371967-8914-1-git-send-email-josh.wu@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 16 Oct 2012 15:19:27 +0800 or thereabout, Josh Wu wrote:
> fixed the following compile error when use avr32 atstk1006_defconfig:
>   drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
>   drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'
> 
> which was introduced by commit 1c7b874d33b463 ("mtd: at91: atmel_nand: add Programmable Multibit ECC controller support").
> The PMECC for nand flash code uses writel_relaxed(). But in avr32, there is no macro "writel_relaxed" defined. This patch add writex_relaxed macro definitions.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  arch/avr32/include/asm/io.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
> index cf60d0a..fc6483f 100644
> --- a/arch/avr32/include/asm/io.h
> +++ b/arch/avr32/include/asm/io.h
> @@ -165,6 +165,10 @@ BUILDIO_IOPORT(l, u32)
>  #define readw_be			__raw_readw
>  #define readl_be			__raw_readl
>  
> +#define writeb_relaxed			writeb
> +#define writew_relaxed			writew
> +#define writel_relaxed			writel
> +

I'm wondering if they should be something similar to SH arch:

#define writeb_relaxed(v,c) ((void)__raw_writeb((__force u8)ioswabb(v),c))

What is the intention behind the macro? Which restriction is relaxed?

>  #define writeb_be			__raw_writeb
>  #define writew_be			__raw_writew
>  #define writel_be			__raw_writel

-- 
mvh
Hans-Christian Egtvedt
