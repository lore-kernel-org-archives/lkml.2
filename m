Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab2LNQHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:07:30 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39298 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2LNQHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:23 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 02/11] remoteproc: Move check on firmware name to rproc_add
Date: Fri, 14 Dec 2012 17:06:51 +0100
Message-Id: <1355501220-4572-3-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Verify that firmware name is defined in rproc_add.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index feb39a7..7d593a1 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -989,13 +989,6 @@ int rproc_boot(struct rproc *rproc)
 		return ret;
 	}
 
-	/* loading a firmware is required */
-	if (!rproc->firmware) {
-		dev_err(dev, "%s: no firmware to load\n", __func__);
-		ret = -EINVAL;
-		goto unlock_mutex;
-	}
-
 	/* prevent underlying implementation from being removed */
 	if (!try_module_get(dev->parent->driver->owner)) {
 		dev_err(dev, "%s: can't get owner\n", __func__);
@@ -1120,6 +1113,12 @@ int rproc_add(struct rproc *rproc)
 	struct device *dev = &rproc->dev;
 	int ret;
 
+	/* loading a firmware is required */
+	if (!rproc->firmware) {
+		dev_err(dev, "%s: no firmware to load\n", __func__);
+		return -EINVAL;
+	}
+
 	ret = device_add(dev);
 	if (ret < 0)
 		return ret;
-- 
1.7.5.4

