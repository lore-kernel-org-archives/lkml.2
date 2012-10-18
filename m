Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2JRACF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:02:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:55809 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab2JRACE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:02:04 -0400
Message-ID: <1350518510.4678.117.camel@pasglop>
Subject: Re: [RESEND PATCH 2/4] asm-generic: io: don't perform swab during
 {in,out} string functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Date: Thu, 18 Oct 2012 11:01:50 +1100
In-Reply-To: <1350488704-3711-3-git-send-email-will.deacon@arm.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
	 <1350488704-3711-3-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 16:45 +0100, Will Deacon wrote:
> The {in,out}s{b,w,l} functions are designed to operate on a stream of
> bytes and therefore should not perform any byte-swapping, regardless of
> the CPU byte order.
> 
> This patch fixes the generic IO header so that {in,out}s{b,w,l} call
> the __raw_{read,write} functions directly rather than going via the
> endian-correcting accessors.
> 
> Cc: Mike Frysinger <vapier@gentoo.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/asm-generic/io.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index 3607921..403b861 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -148,7 +148,7 @@ static inline void insb(unsigned long addr, void *buffer, int count)
>  	if (count) {
>  		u8 *buf = buffer;
>  		do {
> -			u8 x = inb(addr);
> +			u8 x = __raw_readb(addr + PCI_IOBASE);
>  			*buf++ = x;
>  		} while (--count);
>  	}
> @@ -161,7 +161,7 @@ static inline void insw(unsigned long addr, void *buffer, int count)
>  	if (count) {
>  		u16 *buf = buffer;
>  		do {
> -			u16 x = inw(addr);
> +			u16 x = __raw_readw(addr + PCI_IOBASE);
>  			*buf++ = x;
>  		} while (--count);
>  	}
> @@ -174,7 +174,7 @@ static inline void insl(unsigned long addr, void *buffer, int count)
>  	if (count) {
>  		u32 *buf = buffer;
>  		do {
> -			u32 x = inl(addr);
> +			u32 x = __raw_readl(addr + PCI_IOBASE);
>  			*buf++ = x;
>  		} while (--count);
>  	}
> @@ -187,7 +187,7 @@ static inline void outsb(unsigned long addr, const void *buffer, int count)
>  	if (count) {
>  		const u8 *buf = buffer;
>  		do {
> -			outb(*buf++, addr);
> +			__raw_writeb(*buf++, addr + PCI_IOBASE);
>  		} while (--count);
>  	}
>  }
> @@ -199,7 +199,7 @@ static inline void outsw(unsigned long addr, const void *buffer, int count)
>  	if (count) {
>  		const u16 *buf = buffer;
>  		do {
> -			outw(*buf++, addr);
> +			__raw_writew(*buf++, addr + PCI_IOBASE);
>  		} while (--count);
>  	}
>  }
> @@ -211,7 +211,7 @@ static inline void outsl(unsigned long addr, const void *buffer, int count)
>  	if (count) {
>  		const u32 *buf = buffer;
>  		do {
> -			outl(*buf++, addr);
> +			__raw_writel(*buf++, addr + PCI_IOBASE);
>  		} while (--count);
>  	}
>  }


