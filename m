Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1LTTcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:32:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1LTTcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:32:00 -0500
Date: Tue, 20 Dec 2011 20:30:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20111220193012.GA16491@elte.hu>
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

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Clemens Ladisch (1):
      x86, dumpstack: Fix code bytes breakage due to missing KERN_CONT


 arch/x86/kernel/dumpstack_32.c |    8 ++++----
 arch/x86/kernel/dumpstack_64.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 3b97a80..c99f9ed 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -116,16 +116,16 @@ void show_registers(struct pt_regs *regs)
 		for (i = 0; i < code_len; i++, ip++) {
 			if (ip < (u8 *)PAGE_OFFSET ||
 					probe_kernel_address(ip, c)) {
-				printk(" Bad EIP value.");
+				printk(KERN_CONT " Bad EIP value.");
 				break;
 			}
 			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
+				printk(KERN_CONT "<%02x> ", c);
 			else
-				printk("%02x ", c);
+				printk(KERN_CONT "%02x ", c);
 		}
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 int is_valid_bugaddr(unsigned long ip)
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 19853ad..6d728d9 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -284,16 +284,16 @@ void show_registers(struct pt_regs *regs)
 		for (i = 0; i < code_len; i++, ip++) {
 			if (ip < (u8 *)PAGE_OFFSET ||
 					probe_kernel_address(ip, c)) {
-				printk(" Bad RIP value.");
+				printk(KERN_CONT " Bad RIP value.");
 				break;
 			}
 			if (ip == (u8 *)regs->ip)
-				printk("<%02x> ", c);
+				printk(KERN_CONT "<%02x> ", c);
 			else
-				printk("%02x ", c);
+				printk(KERN_CONT "%02x ", c);
 		}
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 }
 
 int is_valid_bugaddr(unsigned long ip)
