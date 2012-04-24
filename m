Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2DXFve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 01:51:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXFvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 01:51:33 -0400
Date: Tue, 24 Apr 2012 00:51:23 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Ben Hutchings <ben@decadent.org.uk>,
        =?utf-8?B?UmHDumw=?= Porcel <armin76@gentoo.org>
Subject: Re: [PATCH] alpha: add io{read,write}{16,32}be functions
Message-ID: <20120424055123.GA7140@burratino>
References: <1322640100-14534-1-git-send-email-mcree@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322640100-14534-1-git-send-email-mcree@orcon.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt et al,

Michael Cree wrote:

> These functions are used in some PCI drivers with big-endian
> MMIO space.
>
> Admittedly it is almost certain that no one this side of the
> Moon would use such a card in an Alpha but it does get us
> closer to being able to build allyesconfig or allmodconfig,
[...]
> --- a/arch/alpha/include/asm/io.h
> +++ b/arch/alpha/include/asm/io.h
> @@ -490,6 +490,11 @@ extern inline void writeq(u64 b, volatile void __iomem *addr)
>  }
>  #endif
>  
> +#define ioread16be(p) be16_to_cpu(ioread16(p))
> +#define ioread32be(p) be32_to_cpu(ioread32(p))
> +#define iowrite16be(v,p) iowrite16(cpu_to_be16(v), (p))
> +#define iowrite32be(v,p) iowrite32(cpu_to_be32(v), (p))
> +
>  #define inb_p		inb

This patch has been in use in Debian's development branch since
January.  Does it look sensible to you?  (If so, I'd like to see it in
mainline eventually so we can more easily share bugfixes depending on
it in the future.)

Thanks,
Jonathan
