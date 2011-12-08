Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab1LHDQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:16:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52504 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756793Ab1LHDQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:16:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] mfd: Store wm8350 struct in core device driver data
Date: Thu,  8 Dec 2011 10:55:21 +0800
Message-Id: <1323312922-29813-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow us to move to a more idiomatic MFD model as drivers
will be able to get the struct by looking at their parent device.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index e81cc31..dd1caaa 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -573,6 +573,8 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 	u16 id1, id2, mask_rev;
 	u16 cust_id, mode, chip_rev;
 
+	dev_set_drvdata(wm8350->dev, wm8350);
+
 	/* get WM8350 revision and config mode */
 	ret = wm8350->read_dev(wm8350, WM8350_RESET_ID, sizeof(id1), &id1);
 	if (ret != 0) {
-- 
1.7.7.3

