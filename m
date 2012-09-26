Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2IZRT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:19:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757646Ab2IZRSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:45 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922253"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 09/12] workqueue: declare system_highpri_wq
Date: Thu, 27 Sep 2012 01:20:40 +0800
Message-Id: <1348680043-5077-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:46,
	Serialize complete at 2012/09/27 01:18:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

system_highpri_wq is missed in workqueue.h, add it back.
also add a short comment for it.

CC: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2b58905..68b1d2a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -294,6 +294,9 @@ enum {
  * short queue flush time.  Don't queue works which can run for too
  * long.
  *
+ * system_highpri_wq is similar to system_wq but services for urgent works
+ * and works will be processed in high priority workers.
+ *
  * system_long_wq is similar to system_wq but may host long running
  * works.  Queue flushing might take relatively long.
  *
@@ -306,6 +309,7 @@ enum {
  * freezable.
  */
 extern struct workqueue_struct *system_wq;
+extern struct workqueue_struct *system_highpri_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
-- 
1.7.7.6

