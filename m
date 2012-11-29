Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab2K2IpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:45:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab2K2InD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:03 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299571"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/8] srcu: add might_sleep() annotation to synchronize_srcu()
Date: Thu, 29 Nov 2012 16:46:03 +0800
Message-Id: <1354178770-6028-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize complete at 2012/11/29 16:42:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize_srcu() can sleep but it will not sleep if the fast path
succeeds. This annotation will helps us to catch the problem early
if it is called in a wrong contex which can't sleep.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index b2e4f36..48d0edb 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -417,6 +417,7 @@ static void __synchronize_srcu(struct srcu_struct *sp, int trycount)
 			   !lock_is_held(&rcu_sched_lock_map),
 			   "Illegal synchronize_srcu() in same-type SRCU (or RCU) read-side critical section");
 
+	might_sleep();
 	init_completion(&rcu.completion);
 
 	head->next = NULL;
-- 
1.7.4.4

