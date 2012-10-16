Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2JPO7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 10:59:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:2900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2JPO7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 10:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="235797878"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Mattia Dongili <malattia@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        platform-driver-x86@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [PATCH 4/5] sonypi: suspend/resume callbacks should be conditionally compiled on CONFIG_PM_SLEEP
Date: Tue, 16 Oct 2012 22:59:04 +0800
Message-Id: <1350399545-11179-4-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1350399545-11179-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will fix warnings like following when CONFIG_PM_SLEEP is not set:

        warning: 'xxx_suspend' defined but not used [-Wunused-function]
        warning: 'xxx_resume' defined but not used [-Wunused-function]

Because
	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)

Only references the callbacks on CONFIG_PM_SLEEP (instead of CONFIG_PM).

Cc: Mattia Dongili <malattia@linux.it>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: platform-driver-x86@vger.kernel.org
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/char/sonypi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 320debb..9b4f011 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1456,7 +1456,7 @@ static int __devexit sonypi_remove(struct platform_device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int old_camera_power;
 
 static int sonypi_suspend(struct device *dev)
-- 
1.7.7.6

