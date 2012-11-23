Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2KWU2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:28:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948Ab2KWU2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:28:09 -0500
Date: Fri, 23 Nov 2012 21:28:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] uprobes: Kill the "uprobe != NULL" check in
	uprobe_unregister()
Message-ID: <20121123202802.GA18884@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123202741.GA18858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial. uprobe can't be NULL after mutex_unlock(), it was already used.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index e9f22ed..13b247c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -900,8 +900,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 	}
 
 	mutex_unlock(uprobes_hash(inode));
-	if (uprobe)
-		put_uprobe(uprobe);
+	put_uprobe(uprobe);
 }
 
 static struct rb_node *
-- 
1.5.5.1

