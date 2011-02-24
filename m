Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1BXXVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:21:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab1BXXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:21:35 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=RFpNunknxTMA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=Ew52lD3e8ZPqI7TFPsoA:9 a=RaEHaKsBCHpFKNam-gQA:7 a=KzogH4GNq4COmO0QpZpnUWSrQHUA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 24 Feb 2011 18:21:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Cleanup of asm-offsets.c(PAGE_SIZE_asm,
 PAGE_SHIFT_asm, THREAD_SIZE_asm)
Message-ID: <20110224232130.GF888@home.goodmis.org>
References: <1298472122-4967-1-git-send-email-psomas@cslab.ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298472122-4967-1-git-send-email-psomas@cslab.ece.ntua.gr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Cc to those that may care ]

On Wed, Feb 23, 2011 at 04:42:02PM +0200, Stratos Psomadakis wrote:
> I noticed that PAGE_SIZE_asm, PAGE_SHIFT_asm, and THREAD_SIZE_asm in asm-offsets.c were 
> no longer needed(since the _AC macro defined in include/linux/const.h makes PAGE_SIZE etc
> 'work' with as).
> 
> Unless I'm missing something here, PAGE_SIZE_asm/PAGE_SHIFT_asm/THREAD_SIZE_asm can be safely
> removed from asm-offsets.c, and be replaced by their non-'_asm' counterparts in the code that 
> uses them.
> Right?
> 
> The kernel builds cleanly after the patch is applied.
> 
> (I know that even if the patch is 'correct', it's as 'important', as a patch fixing typos
> in comments/documentation, but anyway :/ )

This patch makes sense to me.

-- Steve


> 
> 
> Signed-off-by: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
> ---
>  arch/mn10300/kernel/asm-offsets.c      |    2 +-
>  arch/mn10300/kernel/gdb-io-ttysm-low.S |    2 +-
>  arch/x86/kernel/asm-offsets_32.c       |    4 ----
>  arch/x86/kernel/asm-offsets_64.c       |    1 -
>  arch/x86/kernel/entry_32.S             |    2 +-
>  arch/x86/kernel/head_32.S              |    8 ++++----
>  arch/x86/xen/xen-head.S                |    4 ++--
>  7 files changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/mn10300/kernel/asm-offsets.c b/arch/mn10300/kernel/asm-offsets.c
> index 96f24fa..cbe7cda 100644
> --- a/arch/mn10300/kernel/asm-offsets.c
> +++ b/arch/mn10300/kernel/asm-offsets.c
> @@ -89,7 +89,7 @@ void foo(void)
>  	OFFSET(EXEC_DOMAIN_handler,	exec_domain, handler);
>  	OFFSET(RT_SIGFRAME_sigcontext,	rt_sigframe, uc.uc_mcontext);
>  
> -	DEFINE(PAGE_SIZE_asm,		PAGE_SIZE);
> +	DEFINE(PAGE_SIZE,		PAGE_SIZE);
>  
>  	OFFSET(__rx_buffer,		mn10300_serial_port, rx_buffer);
>  	OFFSET(__rx_inp,		mn10300_serial_port, rx_inp);
> diff --git a/arch/mn10300/kernel/gdb-io-ttysm-low.S b/arch/mn10300/kernel/gdb-io-ttysm-low.S
> index 060b7cc..7b2d665 100644
> --- a/arch/mn10300/kernel/gdb-io-ttysm-low.S
> +++ b/arch/mn10300/kernel/gdb-io-ttysm-low.S
> @@ -38,7 +38,7 @@ gdbstub_io_rx_handler:
>  gdbstub_io_rx_more:
>  	mov	a3,a2
>  	add	2,a3
> -	and	PAGE_SIZE_asm-1,a3
> +	and	PAGE_SIZE-1,a3
>  	mov	(gdbstub_rx_outp),d3
>  	cmp	a3,d3
>  	beq	gdbstub_io_rx_overflow
> diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
> index 1a4088d..e1e5009 100644
> --- a/arch/x86/kernel/asm-offsets_32.c
> +++ b/arch/x86/kernel/asm-offsets_32.c
> @@ -97,10 +97,6 @@ void foo(void)
>  	DEFINE(TSS_sysenter_sp0, offsetof(struct tss_struct, x86_tss.sp0) -
>  		 sizeof(struct tss_struct));
>  
> -	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
> -	DEFINE(PAGE_SHIFT_asm, PAGE_SHIFT);
> -	DEFINE(THREAD_SIZE_asm, THREAD_SIZE);
> -
>  	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
>  
>  #ifdef CONFIG_PARAVIRT
> diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
> index 4a6aeed..aab9bdb 100644
> --- a/arch/x86/kernel/asm-offsets_64.c
> +++ b/arch/x86/kernel/asm-offsets_64.c
> @@ -129,7 +129,6 @@ int main(void)
>  	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
>  
>  	BLANK();
> -	DEFINE(PAGE_SIZE_asm, PAGE_SIZE);
>  #ifdef CONFIG_XEN
>  	BLANK();
>  	OFFSET(XEN_vcpu_info_mask, vcpu_info, evtchn_upcall_mask);
> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index c8b4efa..49bdedd 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -395,7 +395,7 @@ sysenter_past_esp:
>  	 * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
>  	 * pushed above; +8 corresponds to copy_thread's esp0 setting.
>  	 */
> -	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE_asm+8+4*4)(%esp)
> +	pushl_cfi ((TI_sysenter_return)-THREAD_SIZE+8+4*4)(%esp)
>  	CFI_REL_OFFSET eip, 0
>  
>  	pushl_cfi %eax
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index 767d6c4..187aa63 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -73,7 +73,7 @@ MAPPING_BEYOND_END = PAGE_TABLE_SIZE(LOWMEM_PAGES) << PAGE_SHIFT
>   */
>  KERNEL_PAGES = LOWMEM_PAGES
>  
> -INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE_asm
> +INIT_MAP_SIZE = PAGE_TABLE_SIZE(KERNEL_PAGES) * PAGE_SIZE
>  RESERVE_BRK(pagetables, INIT_MAP_SIZE)
>  
>  /*
> @@ -623,7 +623,7 @@ ENTRY(initial_code)
>   * BSS section
>   */
>  __PAGE_ALIGNED_BSS
> -	.align PAGE_SIZE_asm
> +	.align PAGE_SIZE
>  #ifdef CONFIG_X86_PAE
>  initial_pg_pmd:
>  	.fill 1024*KPMDS,4,0
> @@ -644,7 +644,7 @@ ENTRY(swapper_pg_dir)
>  #ifdef CONFIG_X86_PAE
>  __PAGE_ALIGNED_DATA
>  	/* Page-aligned for the benefit of paravirt? */
> -	.align PAGE_SIZE_asm
> +	.align PAGE_SIZE
>  ENTRY(initial_page_table)
>  	.long	pa(initial_pg_pmd+PGD_IDENT_ATTR),0	/* low identity map */
>  # if KPMDS == 3
> @@ -662,7 +662,7 @@ ENTRY(initial_page_table)
>  # else
>  #  error "Kernel PMDs should be 1, 2 or 3"
>  # endif
> -	.align PAGE_SIZE_asm		/* needs to be page-sized too */
> +	.align PAGE_SIZE		/* needs to be page-sized too */
>  #endif
>  
>  .data
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 1a5ff24..aaa7291 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -28,9 +28,9 @@ ENTRY(startup_xen)
>  	__FINIT
>  
>  .pushsection .text
> -	.align PAGE_SIZE_asm
> +	.align PAGE_SIZE
>  ENTRY(hypercall_page)
> -	.skip PAGE_SIZE_asm
> +	.skip PAGE_SIZE
>  .popsection
>  
>  	ELFNOTE(Xen, XEN_ELFNOTE_GUEST_OS,       .asciz "linux")
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
