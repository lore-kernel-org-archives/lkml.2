Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab0FRVJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:09:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37939 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0FRVJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:09:08 -0400
Date: Fri, 18 Jun 2010 23:09:00 +0200
From: Andi Kleen <andi@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: [PATCH] x86: Fix vsyscall on gcc 4.5 with -Os
Message-ID: <20100618210859.GA10913@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: Fix vsyscall on gcc 4.5 with -Os

This fixes the -Os breaks with gcc 4.5 bug.
rdtsc_barrier needs to be force inlined, otherwise
user space will jump into kernel space and kill init.

This also addresses 
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44129
I believe

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.34-ak/arch/x86/include/asm/system.h
===================================================================
--- linux-2.6.34-ak.orig/arch/x86/include/asm/system.h
+++ linux-2.6.34-ak/arch/x86/include/asm/system.h
@@ -451,7 +451,7 @@ void stop_this_cpu(void *dummy);
  *
  * (Could use an alternative three way for this if there was one.)
  */
-static inline void rdtsc_barrier(void)
+static __always_inline void rdtsc_barrier(void)
 {
 	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
