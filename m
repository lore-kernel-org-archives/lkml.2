Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2IOIrV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 04:47:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2IOIp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 04:45:28 -0400
X-IronPort-AV: E=Sophos;i="4.80,427,1344182400"; 
   d="scan'208";a="5850809"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 5/6] workqueue: use __cpuinit instead of __devinit for cpu callback
Date: Sat, 15 Sep 2012 16:13:38 +0800
Message-Id: <1347696825-24622-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347696825-24622-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/15 16:12:52,
	Serialize complete at 2012/09/15 16:12:52
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
index 5438c0d..e8d3c95 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3532,7 +3532,7 @@ static void gcwq_unbind_fn(struct work_struct *work)
  * Workqueues should be brought up before normal priority CPU notifiers.
  * This will be registered high priority CPU notifier.
  */
-static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
+static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 					       unsigned long action,
 					       void *hcpu)
 {
@@ -3573,7 +3573,7 @@ static int __devinit workqueue_cpu_up_callback(struct notifier_block *nfb,
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

