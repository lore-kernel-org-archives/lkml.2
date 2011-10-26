Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab1JZQBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 12:01:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933042Ab1JZQBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 12:01:22 -0400
Date: Wed, 26 Oct 2011 17:59:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/vdso changes for v3.2
Message-ID: <20111026155939.GA5928@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vdso-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

 Thanks,

	Ingo

------------------>
Cesar Eduardo Barros (1):
      x86-64, doc: Remove int 0xcc from entry_64.S documentation

H. Peter Anvin (1):
      x86, vsyscall: Add missing <asm/fixmap.h> to arch/x86/mm/fault.c


 Documentation/x86/entry_64.txt |    3 ---
 arch/x86/mm/fault.c            |    1 +
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
index 7869f14..bc7226e 100644
--- a/Documentation/x86/entry_64.txt
+++ b/Documentation/x86/entry_64.txt
@@ -27,9 +27,6 @@ Some of these entries are:
    magically-generated functions that make their way to do_IRQ with
    the interrupt number as a parameter.
 
- - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
-   vsyscall emulation.
-
  - APIC interrupts: Various special-purpose interrupts for things
    like TLB shootdown.
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 247aae3..f2d4c9d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -17,6 +17,7 @@
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
+#include <asm/fixmap.h>			/* VSYSCALL_START		*/
 
 /*
  * Page fault error code bits:
