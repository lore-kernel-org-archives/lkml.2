Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2K2Inw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:43:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1276 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab2K2InE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:04 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299573"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 6/8] srcu: update the comments of synchronize_srcu()
Date: Thu, 29 Nov 2012 16:46:07 +0800
Message-Id: <1354178770-6028-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:33,
	Serialize complete at 2012/11/29 16:42:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core of srcu is changed, but the comments of synchronize_srcu()
describe the old algorithm. Update it to match the new algorithm.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index ac08970..55524f6 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -446,10 +446,12 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
  * synchronize_srcu - wait for prior SRCU read-side critical-section completion
  * @sp: srcu_struct with which to synchronize.
  *
- * Flip the completed counter, and wait for the old count to drain to zero.
- * As with classic RCU, the updater must use some separate means of
- * synchronizing concurrent updates.  Can block; must be called from
- * process context.
+ * Wait for the count to drain to zero of both indexes. To avoid the
+ * possible starvation of synchronize_srcu(), it waits for the count of
+ * the index=((->completed & 1) ^ 1) to drain to zero at first,
+ * and then flip the completed and wait for the count of the other index.
+ *
+ * Can block; must be called from process context.
  *
  * Note that it is illegal to call synchronize_srcu() from the corresponding
  * SRCU read-side critical section; doing so will result in deadlock.
-- 
1.7.4.4

