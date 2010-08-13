Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0HMGKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 02:10:44 -0400
Received: from relais.videotron.ca ([24.201.245.36]:22004 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0HMGKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 02:10:42 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; format=flowed; charset=iso-8859-1; reply-type=original
Message-id: <7A1E1331834343A0BAAC1D16C3FAAEED@delorimier>
From: David Hill <hilld@binarystorm.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org, Dieter Stussy <kd6lvw+software@kd6lvw.ampr.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luca Barbieri <luca@luca-barbieri.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
References: <201008121908.o7CJ8con006200@hera.kernel.org>
Subject: Re: [GIT PULL] x86/urgent for 2.6.36-rc1
Date: Fri, 13 Aug 2010 02:09:52 -0400
X-Priority: 3
X-MSMail-priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
X-Wolfe-MailScanner-ID: 1OjnSo-0001c9-MB
X-Wolfe-MailScanner: Found to be clean
X-Wolfe-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=1.239, required 6,	autolearn=not spam,
 ALL_TRUSTED 1.00, BAYES_50 0.80,	STOX_REPLY_TYPE 0.44,
 TRUSTED_FROM_BINARYSTORM_NET -1.00)
X-Wolfe-MailScanner-From: hilld@binarystorm.net
X-Wolfe-MailScanner-To: ebiederm@xmission.com, hpa@linux.intel.com,
	hpa@zytor.com, kd6lvw+software@kd6lvw.ampr.org,	linux-kernel@vger.kernel.org,
 luca@luca-barbieri.com, mingo@elte.hu,	namhyung@gmail.com, stable@kernel.org,
 tglx@linutronix.de,	torvalds@linux-foundation.org, tvrtko.ursulin@sophos.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eureka!

    This seems to solve my problem!  My Dual P3-500MHZ is now booting with 
that patch.

Good work guys!!!!

Thank you very much,

David C. Hill
----- Original Message ----- 
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>; "David Hill" <hilld@binarystorm.net>; "Dieter 
Stussy" <kd6lvw+software@kd6lvw.ampr.org>; "Eric W. Biederman" 
<ebiederm@xmission.com>; "H. Peter Anvin" <hpa@linux.intel.com>; "H. Peter 
Anvin" <hpa@zytor.com>; "Ingo Molnar" <mingo@elte.hu>; "Linux Kernel Mailing 
List" <linux-kernel@vger.kernel.org>; "Luca Barbieri" 
<luca@luca-barbieri.com>; "Namhyung Kim" <namhyung@gmail.com>; "Thomas 
Gleixner" <tglx@linutronix.de>; "Tvrtko Ursulin" <tvrtko.ursulin@sophos.com>
Sent: Thursday, August 12, 2010 3:08 PM
Subject: [GIT PULL] x86/urgent for 2.6.36-rc1


> Hi Linus,
>
> First batch of x86 fixes.
>
> The following changes since commit 
> ad41a1e0cab07c5125456e8d38e5b1ab148d04aa:
>
>  Merge branch 'io_remap_pfn_range' of git://www.jni.nu/cris (2010-08-12 
> 10:17:19 -0700)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git 
> x86/urgent
>
> Eric W. Biederman (1):
>      x86, apic: Map the local apic when parsing the MP table.
>
> Luca Barbieri (2):
>      x86, asm: Refactor atomic64_386_32.S to support old binutils and be 
> cleaner
>      x86, asm: Use a lower case name for the end macro in 
> atomic64_386_32.S
>
> Namhyung Kim (1):
>      x86: Document __phys_reloc_hide() usage in __pa_symbol()
>
> arch/x86/include/asm/page.h    |    7 +
> arch/x86/kernel/apic/apic.c    |    2 +-
> arch/x86/kernel/mpparse.c      |   16 +++
> arch/x86/lib/atomic64_386_32.S |  238 
> ++++++++++++++++++++++------------------
> 4 files changed, 154 insertions(+), 109 deletions(-)
>
> diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
> index 625c3f0..8ca8283 100644
> --- a/arch/x86/include/asm/page.h
> +++ b/arch/x86/include/asm/page.h
> @@ -37,6 +37,13 @@ static inline void copy_user_page(void *to, void *from, 
> unsigned long vaddr,
> #define __pa_nodebug(x) __phys_addr_nodebug((unsigned long)(x))
> /* __pa_symbol should be used for C visible symbols.
>    This seems to be the official gcc blessed way to do such arithmetic. */
> +/*
> + * We need __phys_reloc_hide() here because gcc may assume that there is 
> no
> + * overflow during __pa() calculation and can optimize it unexpectedly.
> + * Newer versions of gcc provide -fno-strict-overflow switch to handle 
> this
> + * case properly. Once all supported versions of gcc understand it, we 
> can
> + * remove this Voodoo magic stuff. (i.e. once gcc3.x is deprecated)
> + */
> #define __pa_symbol(x) __pa(__phys_reloc_hide((unsigned long)(x)))
>
> #define __va(x) ((void *)((unsigned long)(x)+PAGE_OFFSET))
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 980508c..e3b534c 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1606,7 +1606,7 @@ void __init init_apic_mappings(void)
>  * acpi lapic path already maps that address in
>  * acpi_register_lapic_address()
>  */
> - if (!acpi_lapic)
> + if (!acpi_lapic && !smp_found_config)
>  set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
>
>  apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
> diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
> index d86dbf7..d7b6f7f 100644
> --- a/arch/x86/kernel/mpparse.c
> +++ b/arch/x86/kernel/mpparse.c
> @@ -274,6 +274,18 @@ static void __init smp_dump_mptable(struct mpc_table 
> *mpc, unsigned char *mpt)
>
> void __init default_smp_read_mpc_oem(struct mpc_table *mpc) { }
>
> +static void __init smp_register_lapic_address(unsigned long address)
> +{
> + mp_lapic_addr = address;
> +
> + set_fixmap_nocache(FIX_APIC_BASE, address);
> + if (boot_cpu_physical_apicid == -1U) {
> + boot_cpu_physical_apicid  = read_apic_id();
> + apic_version[boot_cpu_physical_apicid] =
> + GET_APIC_VERSION(apic_read(APIC_LVR));
> + }
> +}
> +
> static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
> {
>  char str[16];
> @@ -295,6 +307,10 @@ static int __init smp_read_mpc(struct mpc_table *mpc, 
> unsigned early)
>  if (early)
>  return 1;
>
> + /* Initialize the lapic mapping */
> + if (!acpi_lapic)
> + smp_register_lapic_address(mpc->lapic);
> +
>  if (mpc->oemptr)
>  x86_init.mpparse.smp_read_mpc_oem(mpc);
>
> diff --git a/arch/x86/lib/atomic64_386_32.S 
> b/arch/x86/lib/atomic64_386_32.S
> index 4a5979a..2cda60a 100644
> --- a/arch/x86/lib/atomic64_386_32.S
> +++ b/arch/x86/lib/atomic64_386_32.S
> @@ -25,150 +25,172 @@
>  CFI_ADJUST_CFA_OFFSET -4
> .endm
>
> -.macro BEGIN func reg
> -$v = \reg
> -
> -ENTRY(atomic64_\func\()_386)
> - CFI_STARTPROC
> - LOCK $v
> -
> -.macro RETURN
> - UNLOCK $v
> +#define BEGIN(op) \
> +.macro endp; \
> + CFI_ENDPROC; \
> +ENDPROC(atomic64_##op##_386); \
> +.purgem endp; \
> +.endm; \
> +ENTRY(atomic64_##op##_386); \
> + CFI_STARTPROC; \
> + LOCK v;
> +
> +#define ENDP endp
> +
> +#define RET \
> + UNLOCK v; \
>  ret
> -.endm
> -
> -.macro END_
> - CFI_ENDPROC
> -ENDPROC(atomic64_\func\()_386)
> -.purgem RETURN
> -.purgem END_
> -.purgem END
> -.endm
> -
> -.macro END
> -RETURN
> -END_
> -.endm
> -.endm
>
> -BEGIN read %ecx
> - movl  ($v), %eax
> - movl 4($v), %edx
> -END
> -
> -BEGIN set %esi
> - movl %ebx,  ($v)
> - movl %ecx, 4($v)
> -END
> -
> -BEGIN xchg %esi
> - movl  ($v), %eax
> - movl 4($v), %edx
> - movl %ebx,  ($v)
> - movl %ecx, 4($v)
> -END
> -
> -BEGIN add %ecx
> - addl %eax,  ($v)
> - adcl %edx, 4($v)
> -END
> -
> -BEGIN add_return %ecx
> - addl  ($v), %eax
> - adcl 4($v), %edx
> - movl %eax,  ($v)
> - movl %edx, 4($v)
> -END
> -
> -BEGIN sub %ecx
> - subl %eax,  ($v)
> - sbbl %edx, 4($v)
> -END
> -
> -BEGIN sub_return %ecx
> +#define RET_ENDP \
> + RET; \
> + ENDP
> +
> +#define v %ecx
> +BEGIN(read)
> + movl  (v), %eax
> + movl 4(v), %edx
> +RET_ENDP
> +#undef v
> +
> +#define v %esi
> +BEGIN(set)
> + movl %ebx,  (v)
> + movl %ecx, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v  %esi
> +BEGIN(xchg)
> + movl  (v), %eax
> + movl 4(v), %edx
> + movl %ebx,  (v)
> + movl %ecx, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %ecx
> +BEGIN(add)
> + addl %eax,  (v)
> + adcl %edx, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %ecx
> +BEGIN(add_return)
> + addl  (v), %eax
> + adcl 4(v), %edx
> + movl %eax,  (v)
> + movl %edx, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %ecx
> +BEGIN(sub)
> + subl %eax,  (v)
> + sbbl %edx, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %ecx
> +BEGIN(sub_return)
>  negl %edx
>  negl %eax
>  sbbl $0, %edx
> - addl  ($v), %eax
> - adcl 4($v), %edx
> - movl %eax,  ($v)
> - movl %edx, 4($v)
> -END
> -
> -BEGIN inc %esi
> - addl $1,  ($v)
> - adcl $0, 4($v)
> -END
> -
> -BEGIN inc_return %esi
> - movl  ($v), %eax
> - movl 4($v), %edx
> + addl  (v), %eax
> + adcl 4(v), %edx
> + movl %eax,  (v)
> + movl %edx, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %esi
> +BEGIN(inc)
> + addl $1,  (v)
> + adcl $0, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %esi
> +BEGIN(inc_return)
> + movl  (v), %eax
> + movl 4(v), %edx
>  addl $1, %eax
>  adcl $0, %edx
> - movl %eax,  ($v)
> - movl %edx, 4($v)
> -END
> -
> -BEGIN dec %esi
> - subl $1,  ($v)
> - sbbl $0, 4($v)
> -END
> -
> -BEGIN dec_return %esi
> - movl  ($v), %eax
> - movl 4($v), %edx
> + movl %eax,  (v)
> + movl %edx, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %esi
> +BEGIN(dec)
> + subl $1,  (v)
> + sbbl $0, 4(v)
> +RET_ENDP
> +#undef v
> +
> +#define v %esi
> +BEGIN(dec_return)
> + movl  (v), %eax
> + movl 4(v), %edx
>  subl $1, %eax
>  sbbl $0, %edx
> - movl %eax,  ($v)
> - movl %edx, 4($v)
> -END
> + movl %eax,  (v)
> + movl %edx, 4(v)
> +RET_ENDP
> +#undef v
>
> -BEGIN add_unless %ecx
> +#define v %ecx
> +BEGIN(add_unless)
>  addl %eax, %esi
>  adcl %edx, %edi
> - addl  ($v), %eax
> - adcl 4($v), %edx
> + addl  (v), %eax
> + adcl 4(v), %edx
>  cmpl %eax, %esi
>  je 3f
> 1:
> - movl %eax,  ($v)
> - movl %edx, 4($v)
> + movl %eax,  (v)
> + movl %edx, 4(v)
>  movl $1, %eax
> 2:
> -RETURN
> + RET
> 3:
>  cmpl %edx, %edi
>  jne 1b
>  xorl %eax, %eax
>  jmp 2b
> -END_
> +ENDP
> +#undef v
>
> -BEGIN inc_not_zero %esi
> - movl  ($v), %eax
> - movl 4($v), %edx
> +#define v %esi
> +BEGIN(inc_not_zero)
> + movl  (v), %eax
> + movl 4(v), %edx
>  testl %eax, %eax
>  je 3f
> 1:
>  addl $1, %eax
>  adcl $0, %edx
> - movl %eax,  ($v)
> - movl %edx, 4($v)
> + movl %eax,  (v)
> + movl %edx, 4(v)
>  movl $1, %eax
> 2:
> -RETURN
> + RET
> 3:
>  testl %edx, %edx
>  jne 1b
>  jmp 2b
> -END_
> +ENDP
> +#undef v
>
> -BEGIN dec_if_positive %esi
> - movl  ($v), %eax
> - movl 4($v), %edx
> +#define v %esi
> +BEGIN(dec_if_positive)
> + movl  (v), %eax
> + movl 4(v), %edx
>  subl $1, %eax
>  sbbl $0, %edx
>  js 1f
> - movl %eax,  ($v)
> - movl %edx, 4($v)
> + movl %eax,  (v)
> + movl %edx, 4(v)
> 1:
> -END
> +RET_ENDP
> +#undef v
>
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
>
> 

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

