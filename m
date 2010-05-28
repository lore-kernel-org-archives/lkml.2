Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0E1HDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 03:03:44 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:45174 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab0E1HDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 03:03:42 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 2/8] cpuidle: add cpuidle_unregister_driver() error check
Date: Fri, 28 May 2010 02:01:55 -0400
Message-id: <c0d64cb031c21f163a0ec15cf10844bcf0ceedcf.1275026041.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.1.231.gd0b16
In-reply-to: <1275026521-30835-1-git-send-email-lenb@kernel.org>
References: <1275026521-30835-1-git-send-email-lenb@kernel.org>
In-reply-to: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
References: <6b2c676bf32be91f43215d5874c07c1becaba013.1275026041.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Assure that cpuidle_unregister_driver() will not clobber
the registered driver if unregistered by somebody else.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/driver.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 2257004..826b5c0 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -45,8 +45,11 @@ EXPORT_SYMBOL_GPL(cpuidle_register_driver);
  */
 void cpuidle_unregister_driver(struct cpuidle_driver *drv)
 {
-	if (!drv)
+	if (drv != cpuidle_curr_driver) {
+		WARN(1, "invalid cpuidle_unregister_driver(%s)\n",
+			drv->name);
 		return;
+	}
 
 	spin_lock(&cpuidle_driver_lock);
 	cpuidle_curr_driver = NULL;
-- 
1.6.0.6

