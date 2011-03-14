Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab1CNU63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:58:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36587 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab1CNU62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:58:28 -0400
From: Julia Lawall <julia@diku.dk>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: kernel-janitors@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/rtc/rtc-mrst.c: Use release_mem_region after request_mem_region
Date: Mon, 14 Mar 2011 22:00:25 +0100
Message-Id: <1300136425-3311-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory allocated using request_mem_region should be released using
release_mem_region, not release_region.

The semantic patch that fixes part of this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1,E2,E3;
@@

request_mem_region(E1,E2,E3)
...
?- release_region(E1,E2)
+ release_mem_region(E1,E2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/rtc/rtc-mrst.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index b86bc32..558dd7d 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -379,7 +379,7 @@ cleanup1:
 	mrst_rtc.dev = NULL;
 	rtc_device_unregister(mrst_rtc.rtc);
 cleanup0:
-	release_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
 }
@@ -405,7 +405,7 @@ static void __exit rtc_mrst_do_remove(struct device *dev)
 	mrst->rtc = NULL;
 
 	iomem = mrst->iomem;
-	release_region(iomem->start, iomem->end + 1 - iomem->start);
+	release_mem_region(iomem->start, iomem->end + 1 - iomem->start);
 	mrst->iomem = NULL;
 
 	mrst->dev = NULL;

