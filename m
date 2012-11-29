Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2K2IpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:45:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:24868 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2K2InD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:43:03 -0500
X-IronPort-AV: E=Sophos;i="4.83,339,1352044800"; 
   d="scan'208";a="6299572"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/8] srcu: simple cleanup for cleanup_srcu_struct()
Date: Thu, 29 Nov 2012 16:46:04 +0800
Message-Id: <1354178770-6028-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
References: <1354178770-6028-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/29 16:42:32,
	Serialize complete at 2012/11/29 16:42:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pack 6 lines of code into 2 lines.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/srcu.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/srcu.c b/kernel/srcu.c
index 48d0edb..ac08970 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -278,12 +278,8 @@ static int srcu_readers_active(struct srcu_struct *sp)
  */
 void cleanup_srcu_struct(struct srcu_struct *sp)
 {
-	int sum;
-
-	sum = srcu_readers_active(sp);
-	WARN_ON(sum);  /* Leakage unless caller handles error. */
-	if (sum != 0)
-		return;
+	if (WARN_ON(srcu_readers_active(sp)))
+		return; /* Leakage unless caller handles error. */
 	free_percpu(sp->per_cpu_ref);
 	sp->per_cpu_ref = NULL;
 }
-- 
1.7.4.4

