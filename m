Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1BBRjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:39:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab1BBRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:39:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: ARM unaligned MMIO access with attribute((packed))
Date: Wed, 2 Feb 2011 18:39:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Peter Maydell <peter.maydell@linaro.org>, gcc@gcc.gnu.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
References: <201102021700.20683.arnd@arndb.de> <20110202163702.GA23240@n2100.arm.linux.org.uk>
In-Reply-To: <20110202163702.GA23240@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Message-Id: <201102021839.17223.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:DRKZruZnChx+zEtE8El6U+OYSdi5F4NoplegRDRGQHp
 m7jtX4TENUsWNWT9vrYAJt9FK+YUTyJW0xYe8P4tNf40KVq5oS
 H0tyfoqyul7dR9GkirOFD0EFsWEnIjYqfndgwYI51FpB5/LXSA
 6sZekzuPAoFAy6AAYvYJQgaqM1DhUUdAkYWK7QqYeejuxDXIQm
 dLuN2oqCfS1+zU8DVk8kA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 February 2011 17:37:02 Russell King - ARM Linux wrote:
> We used to use inline assembly at one point, but that got chucked out.
> The problem is that using asm() for this causes GCC to generate horrid
> code.
> 
> 1. there's no way to tell GCC that the inline assembly is a load
>    instruction and therefore it needs to schedule the following
>    instructions appropriately.
> 
> 2. GCC will needlessly reload pointers from structures and other such
>    behaviour because it can't be told clearly what the inline assembly
>    is doing, so the inline asm needs to have a "memory" clobber.
> 
> 3. It seems to misses out using the pre-index addressing, prefering to
>    create add/sub instructions prior to each inline assembly load/store.
> 
> 4. There are no (documented) constraints in GCC to allow you to represent
>    the offset format for the half-word instructions.
> 
> Overall, it means greater register pressure, more instructions, larger
> functions, greater instruction cache pressure, etc.

Another solution would be to declare the readl function extern and define
it out of line, but I assume that this would be at least as bad as an
inline assembly for all the points you brought up, right?

Would it be possible to add the proper constraints for defining readl
in an efficient way to a future version of gcc? That wouldn't help us
in the near future, but we could at some points use those in a number
of places.

	Arnd
