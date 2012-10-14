Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2JNTXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:23:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2JNTXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:23:41 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 2/9] uprobes: check for single step support
Date: Sun, 14 Oct 2012 21:23:06 +0200
Message-Id: <1350242593-17761-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350242593-17761-1-git-send-email-rabin@rab.in>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for single step support before calling user_enable_single_step(),
since user_enable_single_step() just BUG()s if support does not exist.
Needed by ARM.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 kernel/events/uprobes.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 98256bc..db4e3ab 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1450,7 +1450,8 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 
 void __weak arch_uprobe_enable_step(struct arch_uprobe *arch)
 {
-	user_enable_single_step(current);
+	if (arch_has_single_step())
+		user_enable_single_step(current);
 }
 
 void __weak arch_uprobe_disable_step(struct arch_uprobe *arch)
-- 
1.7.9.5

