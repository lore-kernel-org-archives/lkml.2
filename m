Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2LTTRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:17:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49129 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2LTTOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:23 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] uprobes: remove redundant check
Date: Thu, 20 Dec 2012 14:11:30 -0500
Message-Id: <1356030701-16284-22-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We checked for uprobe==NULL earlier, no need to redo that.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/events/uprobes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index dea7acf..30ea9a4 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -901,8 +901,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	}
 
 	mutex_unlock(uprobes_hash(inode));
-	if (uprobe)
-		put_uprobe(uprobe);
+	put_uprobe(uprobe);
 }
 
 static struct rb_node *
-- 
1.8.0

