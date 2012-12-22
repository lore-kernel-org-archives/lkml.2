Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab2LVCBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:01:23 -0500
Received: from mail-ia0-f169.google.com ([209.85.210.169]:45310 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2LVB63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:29 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-pm@vger.kernel.org
Subject: [PATCH 16/25] PM / Domains: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:06 -0800
Message-Id: <1356141435-17340-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from power domains.  Only compile
tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: linux-pm@vger.kernel.org
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 drivers/base/power/domain.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index acc3a8d..9a6b05a 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -433,8 +433,7 @@ static bool genpd_abort_poweroff(struct generic_pm_domain *genpd)
  */
 void genpd_queue_power_off_work(struct generic_pm_domain *genpd)
 {
-	if (!work_pending(&genpd->power_off_work))
-		queue_work(pm_wq, &genpd->power_off_work);
+	queue_work(pm_wq, &genpd->power_off_work);
 }
 
 /**
-- 
1.8.0.2

