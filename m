Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2JNTZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:25:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2JNTXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:23:47 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 6/9] uprobes: flush cache after xol write
Date: Sun, 14 Oct 2012 21:23:10 +0200
Message-Id: <1350242593-17761-6-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350242593-17761-1-git-send-email-rabin@rab.in>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flush the cache so that the instructions written to the XOL area are
visible.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 kernel/events/uprobes.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ca000a9..8c52f93 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1246,6 +1246,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
 	offset = current->utask->xol_vaddr & ~PAGE_MASK;
 	vaddr = kmap_atomic(area->page);
 	arch_uprobe_xol_copy(&uprobe->arch, vaddr + offset);
+	flush_dcache_page(area->page);
 	kunmap_atomic(vaddr);
 
 	return current->utask->xol_vaddr;
-- 
1.7.9.5

