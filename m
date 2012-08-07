Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2HGQNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:13:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:53151 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2HGQNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:13:14 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/5] uprobes: remove check for uprobe variable in handle_swbp()
Date: Tue,  7 Aug 2012 18:12:30 +0200
Message-Id: <1344355952-2382-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by the time we get here (after we pass cleanup_ret) uprobe is always is
set. If it is NULL we leave very early in the code.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/events/uprobes.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 41a2555..c8e5204 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1528,17 +1528,15 @@ cleanup_ret:
 		utask->active_uprobe = NULL;
 		utask->state = UTASK_RUNNING;
 	}
-	if (uprobe) {
-		if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
+	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
 
-			/*
-			 * cannot singlestep; cannot skip instruction;
-			 * re-execute the instruction.
-			 */
-			instruction_pointer_set(regs, bp_vaddr);
+		/*
+		 * cannot singlestep; cannot skip instruction;
+		 * re-execute the instruction.
+		 */
+		instruction_pointer_set(regs, bp_vaddr);
 
-		put_uprobe(uprobe);
-	}
+	put_uprobe(uprobe);
 }
 
 /*
-- 
1.7.10.4

