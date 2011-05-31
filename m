Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab1EaQae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:30:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab1EaQad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:30:33 -0400
Date: Tue, 31 May 2011 18:30:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110531163022.GA15435@elte.hu>
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

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Avi Kivity (1):
      x86: Fix mwait_play_dead() faulting on mwait-incapable cpus

Borislav Petkov (1):
      x86 idle: Fix mwait deprecation warning message


 arch/x86/kernel/process.c |    2 +-
 arch/x86/kernel/smpboot.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 426a5b6..3d83a71 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
+		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\"\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index eefd967..33a0c11 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1332,7 +1332,7 @@ static inline void mwait_play_dead(void)
 	void *mwait_ptr;
 	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
-	if (!this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c))
+	if (!(this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c)))
 		return;
 	if (!this_cpu_has(X86_FEATURE_CLFLSH))
 		return;
