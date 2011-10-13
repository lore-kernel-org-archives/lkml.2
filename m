Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1JMJCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:02:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38671 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1JMJCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:02:35 -0400
Date: Thu, 13 Oct 2011 11:00:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20111013090054.GA22473@elte.hu>
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

Please pull the latest x86-urgent-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Adrian Bunk (1):
      x86: Default to vsyscall=native for now


 Documentation/kernel-parameters.txt |    7 ++++---
 arch/x86/kernel/vsyscall_64.c       |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 854ed5ca..d6e6724 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2706,10 +2706,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			functions are at fixed addresses, they make nice
 			targets for exploits that can control RIP.
 
-			emulate     [default] Vsyscalls turn into traps and are
-			            emulated reasonably safely.
+			emulate     Vsyscalls turn into traps and are emulated
+			            reasonably safely.
 
-			native      Vsyscalls are native syscall instructions.
+			native      [default] Vsyscalls are native syscall
+			            instructions.
 			            This is a little bit faster than trapping
 			            and makes a few dynamic recompilers work
 			            better than they would in emulation mode.
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 18ae83d..b56c65de 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -56,7 +56,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
 
-static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
 
 static int __init vsyscall_setup(char *str)
 {
