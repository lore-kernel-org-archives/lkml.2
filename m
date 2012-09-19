Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2ISNrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 09:47:06 -0400
Received: from mail.x86-64.org ([217.9.48.20]:36701 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab2ISNrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 09:47:02 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] x86, kprobes: Hide skip_singlestep forward declaration properly
Date: Wed, 19 Sep 2012 15:46:54 +0200
Message-Id: <1348062414-6578-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

I get

arch/x86/kernel/kprobes.c:544:23: warning: ‘skip_singlestep’ declared ‘static’ but never defined [-Wunused-function]

on tip/auto-latest.

Hide the forward declaration in the KPROBES_CAN_USE_FTRACE as it
is done in its callsites.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/kprobes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b7c2a85d1926..ac4188368fdf 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -541,8 +541,11 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
 	return 1;
 }
 
+#ifdef KPROBES_CAN_USE_FTRACE
 static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 				      struct kprobe_ctlblk *kcb);
+#endif
+
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
-- 
1.7.11.rc1

