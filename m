Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2KWU2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:28:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab2KWU2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:28:08 -0500
Date: Fri, 23 Nov 2012 21:28:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] uprobes: Move __set_bit(UPROBE_SKIP_SSTEP) into
	alloc_uprobe()
Message-ID: <20121123202800.GA18877@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123202741.GA18858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic. __set_bit(UPROBE_SKIP_SSTEP) is the part of initialization,
it is not clear why it is set in insert_uprobe().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5e22faf..e9f22ed 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -430,9 +430,6 @@ static struct uprobe *insert_uprobe(struct uprobe *uprobe)
 	u = __insert_uprobe(uprobe);
 	spin_unlock(&uprobes_treelock);
 
-	/* For now assume that the instruction need not be single-stepped */
-	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
-
 	return u;
 }
 
@@ -454,6 +451,8 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	uprobe->offset = offset;
 	init_rwsem(&uprobe->consumer_rwsem);
 	mutex_init(&uprobe->copy_mutex);
+	/* For now assume that the instruction need not be single-stepped */
+	__set_bit(UPROBE_SKIP_SSTEP, &uprobe->flags);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
-- 
1.5.5.1

