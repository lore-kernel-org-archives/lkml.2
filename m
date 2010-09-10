Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0IJSr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 14:47:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50616 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab0IJSrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 14:47:55 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:staging:ti-st: fix kim platform device id
Date: Fri, 10 Sep 2010 15:58:55 -0400
Message-Id: <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Platform devices tend to have id as -1 when only 1 device exist and
a value >=0 when multiple devices exist, since we plan to store all
these platform devices if multiple exist, there was a requirement to
have id to be >=0.
The patch fixes this problem.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/st_kim.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
index 9e99463..be18c7a 100644
--- a/drivers/staging/ti-st/st_kim.c
+++ b/drivers/staging/ti-st/st_kim.c
@@ -638,7 +638,14 @@ static int kim_probe(struct platform_device *pdev)
 	long *gpios = pdev->dev.platform_data;
 	struct kim_data_s	*kim_gdata;
 
-	st_kim_devices[pdev->id] = pdev;
+	if ((pdev->id != -1) && (pdev->id < MAX_ST_DEVICES)) {
+		/* multiple devices could exist */
+		st_kim_devices[pdev->id] = pdev;
+	} else {
+		/* platform's sure about existance of 1 device */
+		st_kim_devices[0] = pdev;
+	}
+
 	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
 	if (!kim_gdata) {
 		pr_err("no mem to allocate");
-- 
1.6.5

