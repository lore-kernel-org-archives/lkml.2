Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2K2InM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:43:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2K2InF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:05 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299577"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 7/8] srcu: update the comments of synchronize_srcu_expedited()
Date: Thu, 29 Nov 2012 16:46:08 +0800
Message-Id: <1354178770-6028-8-git-send-email-laijs@cn.fujitsu.com>
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

The new synchronize_srcu_expedited() does not use synchronize_rcu_sched_expedited(),
it removed such lock dependence.

This patch only removes this small piece of the comments:
"it is illegal to call this function while holding any lock
that is acquired by a CPU-hotplug notifier"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 55524f6..38a762f 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -471,12 +471,11 @@ EXPORT_SYMBOL_GPL(synchronize_srcu);
  * Wait for an SRCU grace period to elapse, but be more aggressive about
  * spinning rather than blocking when waiting.
  *
- * Note that it is illegal to call this function while holding any lock
- * that is acquired by a CPU-hotplug notifier.  It is also illegal to call
- * synchronize_srcu_expedited() from the corresponding SRCU read-side
- * critical section; doing so will result in deadlock.  However, it is
- * perfectly legal to call synchronize_srcu_expedited() on one srcu_struct
- * from some other srcu_struct's read-side critical section, as long as
+ * Note that it is also illegal to call synchronize_srcu_expedited()
+ * from the corresponding SRCU read-side critical section;
+ * doing so will result in deadlock.  However, it is perfectly legal
+ * to call synchronize_srcu_expedited() on one srcu_struct from some
+ * other srcu_struct's read-side critical section, as long as
  * the resulting graph of srcu_structs is acyclic.
  */
 void synchronize_srcu_expedited(struct srcu_struct *sp)
-- 
1.7.4.4

