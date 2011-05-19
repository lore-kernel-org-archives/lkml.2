Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753Ab1ESUrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:47:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077Ab1ESUrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:47:32 -0400
Date: Thu, 19 May 2011 22:47:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups changes for v2.6.40
Message-ID: <20110519204714.GA32252@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Bart Van Assche (1):
      x86: Fix spelling error in the memcpy() source code comment

Luis R. Rodriguez (1):
      x86: Fix mrst sparse complaints

Rakib Mullick (1):
      x86, mpparse: Remove unnecessary variable


 arch/x86/kernel/mpparse.c     |    4 +---
 arch/x86/lib/memcpy_64.S      |    2 +-
 arch/x86/platform/mrst/mrst.c |    4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 5a532ce..ef59817 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -718,14 +718,12 @@ static void __init check_irq_src(struct mpc_intsrc *m, int *nr_m_spare)
 static int
 check_slot(unsigned long mpc_new_phys, unsigned long mpc_new_length, int count)
 {
-	int ret = 0;
-
 	if (!mpc_new_phys || count <= mpc_new_length) {
 		WARN(1, "update_mptable: No spare slots (length: %x)\n", count);
 		return -1;
 	}
 
-	return ret;
+	return 0;
 }
 #else /* CONFIG_X86_IO_APIC */
 static
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 75ef61e..2a560bb 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -49,7 +49,7 @@ ENTRY(memcpy)
 	jb .Lhandle_tail
 
 	/*
-	 * We check whether memory false dependece could occur,
+	 * We check whether memory false dependence could occur,
 	 * then jump to corresponding copy mode.
 	 */
 	cmp  %dil, %sil
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 275dbc1..7000e74 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -194,7 +194,7 @@ static unsigned long __init mrst_calibrate_tsc(void)
 	return 0;
 }
 
-void __init mrst_time_init(void)
+static void __init mrst_time_init(void)
 {
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	switch (mrst_timer_options) {
@@ -216,7 +216,7 @@ void __init mrst_time_init(void)
 	apbt_time_init();
 }
 
-void __cpuinit mrst_arch_setup(void)
+static void __cpuinit mrst_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
 		__mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
