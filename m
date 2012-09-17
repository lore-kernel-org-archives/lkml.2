Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab2IQPqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:46:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab2IQPo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:44:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,437,1344182400"; 
   d="scan'208";a="5859721"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V2 for-next PATCH 6/7] workqueue: use __cpuinit instead of __devinit for cpu callback
Date: Mon, 17 Sep 2012 23:46:47 +0800
Message-Id: <1347896808-2398-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347896808-2398-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/17 23:45:06,
	Serialize complete at 2012/09/17 23:45:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes less sense to use __devinit(the memory will be discard
after boot when !HOTPLUG).

It will be more accurate to to use __cpuinit(the memory will be discard
after boot when !HOTPLUG_CPU).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1014b17..2adb316 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3556,7 +3556,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
  * Workqueues should be brought up before normal priority CPU notifiers.
  * This will be registered high priority CPU notifier.
  */
-static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
+static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 					       unsigned long action,
 					       void *hcpu)
 {
@@ -3597,7 +3597,7 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
  * Workqueues should be brought down after normal priority CPU notifiers.
  * This will be registered as low priority CPU notifier.
  */
-static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
+static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 						 unsigned long action,
 						 void *hcpu)
 {
-- 
1.7.4.4

