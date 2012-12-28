Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2L1VpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 16:45:01 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:60082 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754460Ab2L1Voz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 16:44:55 -0500
Date: Fri, 28 Dec 2012 22:44:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: Export min_low_pfn if CONFIG_FLATMEM
Message-ID: <20121228214448.GB6786@linux-mips.org>
References: <1356727256-3172-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356727256-3172-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 09:40:56PM +0100, Geert Uytterhoeven wrote:

> Subject: [PATCH] mips: Export min_low_pfn if CONFIG_FLATMEM
> 
> If CONFIG_FLATMEM=y on MIPS, pfn_valid() (and thus virt_addr_valid()) uses
> min_low_pfn. However, min_low_pfn is not exported by the generic bootmem
> code.
> 
> As of commit e52a29326462badd9ceec90a9eb2ac2a8550e02e ("aoe: avoid races
> between device destruction and discovery"), aoeblk_open() uses
> virt_addr_valid(), causing a link error in the modular case:
> 
>     ERROR: "min_low_pfn" [drivers/block/aoe/aoe.ko] undefined!
> 
> Add a custom export to fix this, just like is done for ia64 in
> arch/ia64/kernel/ia64_ksyms.c.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/7864918/
> 
>  arch/mips/kernel/mips_ksyms.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/kernel/mips_ksyms.c b/arch/mips/kernel/mips_ksyms.c
> index df1e3e4..8579bb8 100644
> --- a/arch/mips/kernel/mips_ksyms.c
> +++ b/arch/mips/kernel/mips_ksyms.c
> @@ -60,3 +60,8 @@ EXPORT_SYMBOL(invalid_pte_table);
>  /* _mcount is defined in arch/mips/kernel/mcount.S */
>  EXPORT_SYMBOL(_mcount);
>  #endif
> +
> +#ifdef CONFIG_FLATMEM
> +#include <linux/bootmem.h>
> +EXPORT_SYMBOL(min_low_pfn);	/* defined by bootmem.c, but not exported by generic code */
> +#endif

I've already applied a different patch which turns virt_addr_valid() into
a normal function and exports it.

Thanks,

  Ralf
