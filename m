Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2GFP3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:29:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:57629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592Ab2GFP2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:28:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="167955943"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 6/6] staging: ccg: print MAC addresses via %pM
Date: Fri,  6 Jul 2012 18:28:18 +0300
Message-Id: <1341588498-21689-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/staging/ccg/ccg.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccg/ccg.c b/drivers/staging/ccg/ccg.c
index a5b36a9..62f5d92 100644
--- a/drivers/staging/ccg/ccg.c
+++ b/drivers/staging/ccg/ccg.c
@@ -564,9 +564,7 @@ static int rndis_function_bind_config(struct ccg_usb_function *f,
 		return -1;
 	}
 
-	pr_info("%s MAC: %02X:%02X:%02X:%02X:%02X:%02X\n", __func__,
-		rndis->ethaddr[0], rndis->ethaddr[1], rndis->ethaddr[2],
-		rndis->ethaddr[3], rndis->ethaddr[4], rndis->ethaddr[5]);
+	pr_info("%s MAC: pM\n", __func__, rndis->ethaddr);
 
 	ret = gether_setup_name(c->cdev->gadget, rndis->ethaddr, "rndis");
 	if (ret) {
@@ -654,9 +652,7 @@ static ssize_t rndis_ethaddr_show(struct device *dev,
 {
 	struct ccg_usb_function *f = dev_get_drvdata(dev);
 	struct rndis_function_config *rndis = f->config;
-	return sprintf(buf, "%02x:%02x:%02x:%02x:%02x:%02x\n",
-		rndis->ethaddr[0], rndis->ethaddr[1], rndis->ethaddr[2],
-		rndis->ethaddr[3], rndis->ethaddr[4], rndis->ethaddr[5]);
+	return sprintf(buf, "%pM\n", rndis->ethaddr);
 }
 
 static ssize_t rndis_ethaddr_store(struct device *dev,
-- 
1.7.10.4

