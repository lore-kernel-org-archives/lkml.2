Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab0G1Et5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 00:49:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:57763 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0G1Etx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 00:49:53 -0400
Subject: Re: [PATCH 01/16] x86, memblock: Add
 memblock_x86_find_in_range_size()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <1279824241-17582-2-git-send-email-yinghai@kernel.org>
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>
	 <1279824241-17582-2-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 14:49:18 +1000
Message-ID: <1280292558.1970.222.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:43 -0700, Yinghai Lu wrote:
> size is returned according free range.
> Will be used to find free ranges for early_memtest and memory corruption check
> 
> Do not mess it up with lib/memblock.c yet.

So I'm readying my branch which incudes your 6 patches, however I'm
still not happy with a few things.

For example, I really really don't like exporting
memblock_reserved_init_regions.

So you do those things for the sake of x86, so let's walk through your
x86 patches and see if I can figure out what you do wrong :-)

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/memblock.h |    8 ++++
>  arch/x86/mm/Makefile            |    2 +
>  arch/x86/mm/memblock.c          |   88 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 98 insertions(+), 0 deletions(-)
>  create mode 100644 arch/x86/include/asm/memblock.h
>  create mode 100644 arch/x86/mm/memblock.c
> 
> diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
> new file mode 100644
> index 0000000..c14219a
> --- /dev/null
> +++ b/arch/x86/include/asm/memblock.h
> @@ -0,0 +1,8 @@
> +#ifndef _X86_MEMBLOCK_H
> +#define _X86_MEMBLOCK_H
> +
> +#define ARCH_DISCARD_MEMBLOCK

So I'm no fan of this ARCH_DISCARD_MEMBLOCK, especially since it makes a
lot of sense to keep the debugfs files around or maybe even move to
sysfs for diagnostic purposes.

Maybe we should consider something better by having memblock always be
init/initdata but we copy the arrays to a "final" location from an
initcall ? We can keep your patches for now, but I think we should
improve on that.
 
> +u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);

I really really don't like your function naming. The above doesn't give
me any bloody idea about what the purpose of the function is...

Cheers,
Ben.


