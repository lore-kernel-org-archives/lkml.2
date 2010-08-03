Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0HCSXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:23:34 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19500 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab0HCSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:22:50 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, hschauhan@nulltrace.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 4/5] samples: kprobe_example: Make it print something on MIPS.
Date: Tue,  3 Aug 2010 11:22:21 -0700
Message-Id: <1280859742-26364-5-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
References: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 03 Aug 2010 18:22:48.0266 (UTC) FILETIME=[E030A2A0:01CB3338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This KProbes example is a little useless if it doesn't print anything.
For MIPS print similar messages to those produced on x86 and PPC.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 samples/kprobes/kprobe_example.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
index a681998..ebf5e0c 100644
--- a/samples/kprobes/kprobe_example.c
+++ b/samples/kprobes/kprobe_example.c
@@ -32,6 +32,11 @@ static int handler_pre(struct kprobe *p, struct pt_regs *regs)
 			" msr = 0x%lx\n",
 		p->addr, regs->nip, regs->msr);
 #endif
+#ifdef CONFIG_MIPS
+	printk(KERN_INFO "pre_handler: p->addr = 0x%p, epc = 0x%lx,"
+			" status = 0x%lx\n",
+		p->addr, regs->cp0_epc, regs->cp0_status);
+#endif
 
 	/* A dump_stack() here will give a stack backtrace */
 	return 0;
@@ -49,6 +54,10 @@ static void handler_post(struct kprobe *p, struct pt_regs *regs,
 	printk(KERN_INFO "post_handler: p->addr = 0x%p, msr = 0x%lx\n",
 		p->addr, regs->msr);
 #endif
+#ifdef CONFIG_MIPS
+	printk(KERN_INFO "post_handler: p->addr = 0x%p, status = 0x%lx\n",
+		p->addr, regs->cp0_status);
+#endif
 }
 
 /*
-- 
1.7.1.1

