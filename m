Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab2FATn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:43:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45581 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759223Ab2FATn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:43:27 -0400
From: Emil Goode <emilgoode@gmail.com>
To: giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] pps: Return PTR_ERR on error in device_create
Date: Fri,  1 Jun 2012 21:43:29 +0200
Message-Id: <1338579809-11637-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should return PTR_ERR if the call to the
device_create function fails.
Without this patch we instead return the value
from a successful call to cdev_add if the call
to device_create fails.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/pps/pps.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 98fbe62..e771487 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -327,8 +327,10 @@ int pps_register_cdev(struct pps_device *pps)
 	}
 	pps->dev = device_create(pps_class, pps->info.dev, devt, pps,
 							"pps%d", pps->id);
-	if (IS_ERR(pps->dev))
+	if (IS_ERR(pps->dev)) {
+		err = PTR_ERR(pps->dev);
 		goto del_cdev;
+	}
 
 	pps->dev->release = pps_device_destruct;
 
-- 
1.7.10

