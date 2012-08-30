Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab2H3R0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:26:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:60890 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2H3R0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:26:32 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: ananth@in.ibm.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        oleg@redhat.com, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] uprobes: don't put NULL pointer in uprobe_register()
Date: Thu, 30 Aug 2012 19:26:22 +0200
Message-Id: <1346347582-20945-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_uprobe() might return a NULL pointer, put_uprobe() can't deal with
this.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/events/uprobes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 7b3112c..30f3e23 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -897,7 +897,8 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	}
 
 	mutex_unlock(uprobes_hash(inode));
-	put_uprobe(uprobe);
+	if (uprobe)
+		put_uprobe(uprobe);
 
 	return ret;
 }
-- 
1.7.10.4

