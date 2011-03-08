Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1CHLox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:44:53 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:34472 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab1CHLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:44:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ctf/RbBZT7cTaWzESddJkGm3RhdGST7hkOlfxZyefLzv8Wbb8RlDjWYyyWL9SeogmG
         zYxxjO7XF+bLRWJc913Mp7xn8qKgOcWfNZZ52XbbzY/VG/1V5C12d46vjPDavFrfuZD6
         YH/HzeIfsHAOYGdt/vZ8E9YItGTzY666r69js=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 -tip 2/4] x86, dumpstack: Random printk changes
Date: Tue,  8 Mar 2011 20:44:20 +0900
Message-Id: <1299584662-24421-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
References: <1299584662-24421-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use KERN_CONT level if messages are continued from previous one.
Also remove a pair of angle brackets on EOE for consistency.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/dumpstack_32.c |    8 ++++----
 arch/x86/kernel/dumpstack_64.c |   10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 3b97a80ce329..c99f9ed013d5 100644
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
index e71c98d3c0d2..50aa303f6611 100644
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
-- 
1.7.4

