Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab2AIQjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:39:17 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44421 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932290Ab2AIQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:39:15 -0500
Date: Mon, 9 Jan 2012 08:39:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Compile errors on 32-bit build due to
 d4bbf7e7759afc172e2bfbc5c416324590049cdd
Message-ID: <20120109163910.GA21732@google.com>
References: <20120108024029.GA17214@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120108024029.GA17214@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Konrad.

On Sat, Jan 07, 2012 at 09:40:29PM -0500, Konrad Rzeszutek Wilk wrote:
> Hey Tejun
> 
> Your patch titled " Merge branch 'master' into x86/memblock" breaks compilation
> under 32-bit with CONFIG_XEN=y.
> 
> /home/konrad/linux-linus/arch/x86/xen/mmu.c: In function ‘xen_setup_kernel_pagetable’:
> /home/konrad/linux-linus/arch/x86/xen/mmu.c:1855: error: expected ‘;’ before ‘)’ token
> /home/konrad/linux-linus/arch/x86/xen/mmu.c:1855: error: expected statement before ‘)’ token
> 
> Looking at merge it looks like you added an extra ')'?
> 
> This patch below fixes it, which I was thinking to attach it to my tree that I will
> send on Monday to Linus.
> 
> From 18ae9edebde83ef358e997e319868d664fb2ddb8 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Sat, 7 Jan 2012 21:27:38 -0500
> Subject: [PATCH] xen/mmu: Fix compile errors introduced by x86/memblock mismerge.
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> The git commit d4bbf7e7759afc172e2bfbc5c416324590049cdd
> "Merge branch 'master' into x86/memblock" mismerged the 32-bit
> section causing:
> 
> arch/x86/xen/mmu.c: In function ‘xen_setup_kernel_pagetable’:
> arch/x86/xen/mmu.c:1855: error: expected ‘;’ before ‘)’ token
> arch/x86/xen/mmu.c:1855: error: expected statement before ‘)’ token
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index f4bf8aa..58a0e46 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1852,7 +1852,7 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
>  	xen_write_cr3(__pa(initial_page_table));
>  
>  	memblock_reserve(__pa(xen_start_info->pt_base),
> -			 xen_start_info->nr_pt_frames * PAGE_SIZE));
> +			 xen_start_info->nr_pt_frames * PAGE_SIZE);

Oops, how did that get through?  Sorry about that.

 Acked-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
