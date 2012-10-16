Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2JPO7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:59:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:60119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab2JPO7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:59:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235797853"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jaxboe@fusionio.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 3/5] mg_disk: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP
Date: Tue, 16 Oct 2012 22:59:03 +0800
Message-Id: <1350399545-11179-3-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will fix warnings like following when CONFIG_PM_SLEEP is not set:

        warning: 'xxx_suspend' defined but not used [-Wunused-function]
        warning: 'xxx_resume' defined but not used [-Wunused-function]

Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/block/mg_disk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 1788f491..532bb89 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -780,6 +780,7 @@ static const struct block_device_operations mg_disk_ops = {
 	.getgeo = mg_getgeo
 };
 
+#ifdef CONFIG_PM_SLEEP
 static int mg_suspend(struct device *dev)
 {
 	struct mg_drv_data *prv_data = dev->platform_data;
@@ -824,6 +825,7 @@ static int mg_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(mg_pm, mg_suspend, mg_resume);
 
-- 
1.7.7.6

