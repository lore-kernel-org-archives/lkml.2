Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1GWJ0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:26:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54551 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1GWJ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:26:42 -0400
Date: Sat, 23 Jul 2011 11:25:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/kexec change for v3.1
Message-ID: <20110723092558.GA20219@elte.hu>
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

Please pull the latest x86-kexec-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-kexec-for-linus

 Thanks,

	Ingo

------------------>
Huang Ying (1):
      kexec, x86: Fix incorrect jump back address if not preserving context


 arch/x86/kernel/relocate_kernel_32.S |    2 ++
 arch/x86/kernel/relocate_kernel_64.S |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index 4123553..36818f8 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -97,6 +97,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushl	$0
 	/* store the start address on the stack */
 	pushl   %edx
 
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 4de8f5b..7a6f3b3 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -100,6 +100,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
 
