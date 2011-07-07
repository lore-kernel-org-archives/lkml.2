Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1GGBOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 21:14:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33498 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab1GGBOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 21:14:06 -0400
Date: Thu, 7 Jul 2011 11:14:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-Id: <20110707111400.be08512d2dbf60be3022ac50@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Today's linux-next merge of the arm-lpae tree got a conflict in
arch/arm/include/asm/proc-fns.h between commit eca5dc2a0028 ("ARM:
6988/1: multi-cpu: remove arguments from CPU proc macros") from the arm
tree and commit 91bcc1122ff9 ("ARM: LPAE: Page table maintenance for the
3-level format") from the arm-lpae tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/proc-fns.h
index 633d1cb,b5db4f4..0000000
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@@ -79,16 -83,24 +83,20 @@@ extern void cpu_proc_fin(void)
  extern int cpu_do_idle(void);
  extern void cpu_dcache_clean_area(void *, int);
  extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+ #ifdef CONFIG_ARM_LPAE
+ extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
+ #else
  extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte, unsigned int ext);
+ #endif
  extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
  #else
 -#define cpu_proc_init()			processor._proc_init()
 -#define cpu_proc_fin()			processor._proc_fin()
 -#define cpu_reset(addr)			processor.reset(addr)
 -#define cpu_do_idle()			processor._do_idle()
 -#define cpu_dcache_clean_area(addr,sz)	processor.dcache_clean_area(addr,sz)
 -#ifdef CONFIG_ARM_LPAE
 -#define cpu_set_pte_ext(ptep,pte)	processor.set_pte_ext(ptep,pte)
 -#else
 -#define cpu_set_pte_ext(ptep,pte,ext)	processor.set_pte_ext(ptep,pte,ext)
 -#endif
 -#define cpu_do_switch_mm(pgd,mm)	processor.switch_mm(pgd,mm)
 +#define cpu_proc_init			processor._proc_init
 +#define cpu_proc_fin			processor._proc_fin
 +#define cpu_reset			processor.reset
 +#define cpu_do_idle			processor._do_idle
 +#define cpu_dcache_clean_area		processor.dcache_clean_area
 +#define cpu_set_pte_ext			processor.set_pte_ext
 +#define cpu_do_switch_mm		processor.switch_mm
  #endif
  
  extern void cpu_resume(void);
