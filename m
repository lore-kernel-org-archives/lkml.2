Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1IGGGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:06:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:6183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab1IGGFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:05:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,343,1312182000"; 
   d="scan'208";a="48789700"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alan@linux.intel.com, wim@iguana.be,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 08/12 v2] staging: mei: resuming timer regardless of the watchdog timeout value.
Date: Wed,  7 Sep 2011 09:03:14 +0300
Message-Id: <1315375398-29529-9-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
References: <1315375398-29529-1-git-send-email-oren.jer.weil@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the timer_work does not only handle watchdog but also handles mei timeouts.

Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/main.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index 7009937..3b0b703 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -1151,11 +1151,9 @@ static int mei_pci_resume(struct device *device)
 	mei_reset(dev, 1);
 	mutex_unlock(&dev->device_lock);
 
-	/* Start watchdog if stopped in suspend */
-	if (dev->wd_timeout) {
-		dev->wd_due_counter = 1;
-		schedule_delayed_work(&dev->timer_work, HZ);
-	}
+	/* Start timer if stopped in suspend */
+	schedule_delayed_work(&dev->timer_work, HZ);
+
 	return err;
 }
 static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
-- 
1.7.4.1

