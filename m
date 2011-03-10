Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1CJWZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:25:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:60964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab1CJWZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:25:33 -0500
Date: Thu, 10 Mar 2011 22:25:16 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, namhyung@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1299584662-24421-2-git-send-email-namhyung@gmail.com>
References: <1299584662-24421-2-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, dumpstack: Cleanup printks
Message-ID: <tip-2b8689e03cd48bb832b933ce5b6335f30e02c6f9@git.kernel.org>
Git-Commit-ID: 2b8689e03cd48bb832b933ce5b6335f30e02c6f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Mar 2011 22:25:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b8689e03cd48bb832b933ce5b6335f30e02c6f9
Gitweb:     http://git.kernel.org/tip/2b8689e03cd48bb832b933ce5b6335f30e02c6f9
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 8 Mar 2011 20:44:20 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 10 Mar 2011 23:20:30 +0100

x86, dumpstack: Cleanup printks

Use KERN_CONT level if messages are continued from previous one.
Also remove a pair of angle brackets on EOE for consistency.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1299584662-24421-2-git-send-email-namhyung@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/dumpstack_32.c |    8 ++++----
 arch/x86/kernel/dumpstack_64.c |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

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
index e71c98d..50aa303 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -180,7 +180,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 			bp = ops->walk_stack(tinfo, stack, bp, ops,
 					     data, estack_end, &graph);
-			ops->stack(data, "<EOE>");
+			ops->stack(data, "EOE");
 			/*
 			 * We link to the next stack via the
 			 * second-to-last pointer (index -2 to end) in the
@@ -311,16 +311,16 @@ void show_registers(struct pt_regs *regs)
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
