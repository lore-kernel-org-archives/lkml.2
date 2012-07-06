Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab2GFPkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:40:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:39923 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab2GFPkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:40:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="189253007"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [Patch v2] staging: ccg: print MAC addresses via %pM
Date: Fri,  6 Jul 2012 18:39:47 +0300
Message-Id: <1341589187-24009-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAH9JG2XzWS_PF8E4V2bHjq=PtTMEtdDcm1Q03GxK8h4E28Rpjw@mail.gmail.com>
References: <CAH9JG2XzWS_PF8E4V2bHjq=PtTMEtdDcm1Q03GxK8h4E28Rpjw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/staging/ccg/ccg.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccg/ccg.c b/drivers/staging/ccg/ccg.c
index a5b36a9..c77c465 100644
--- a/drivers/staging/ccg/ccg.c
+++ b/drivers/staging/ccg/ccg.c
@@ -564,9 +564,7 @@ static int rndis_function_bind_config(struct ccg_usb_function *f,
 		return -1;
 	}
 
-	pr_info("%s MAC: %02X:%02X:%02X:%02X:%02X:%02X\n", __func__,
-		rndis->ethaddr[0], rndis->ethaddr[1], rndis->ethaddr[2],
-		rndis->ethaddr[3], rndis->ethaddr[4], rndis->ethaddr[5]);
+	pr_info("%s MAC: %pM\n", __func__, rndis->ethaddr);
 
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

