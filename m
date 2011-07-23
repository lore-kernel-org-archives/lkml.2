Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1GWJVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:21:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36218 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1GWJU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:20:58 -0400
Date: Sat, 23 Jul 2011 11:20:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu change for v3.1
Message-ID: <20110723092013.GA18787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

 Thanks,

	Ingo

------------------>
Suresh Siddha (1):
      x86-32, fpu: Fix DNA exception during check_fpu()


 arch/x86/kernel/cpu/bugs.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 525514c..46674fb 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -62,6 +62,8 @@ static void __init check_fpu(void)
 		return;
 	}
 
+	kernel_fpu_begin();
+
 	/*
 	 * trap_init() enabled FXSR and company _before_ testing for FP
 	 * problems here.
@@ -80,6 +82,8 @@ static void __init check_fpu(void)
 		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
 
+	kernel_fpu_end();
+
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
 		printk(KERN_WARNING "Hmm, FPU with FDIV bug.\n");
