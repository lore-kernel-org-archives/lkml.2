Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2KFIRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:17:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:40020 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab2KFIRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:17:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,721,1344236400"; 
   d="scan'208";a="244680316"
Subject: [PATCH 1/7] I2c-nomadik: Fix the usage of
 wait_for_completion_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: linus.walleij@linaro.org, w.sang@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Nov 2012 01:18:37 +0800
Message-ID: <1352222317.15558.1584.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The return value of wait_for_completion_timeout() is always
>= 0 with unsigned int type.

So the condition "ret < 0" or "ret >= 0" is pointless.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/i2c/busses/i2c-nomadik.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index 02c3115..8b2ffcf 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -435,13 +435,6 @@ static int read_i2c(struct nmk_i2c_dev *dev, u16 flags)
 	timeout = wait_for_completion_timeout(
 		&dev->xfer_complete, dev->adap.timeout);
 
-	if (timeout < 0) {
-		dev_err(&dev->adev->dev,
-			"wait_for_completion_timeout "
-			"returned %d waiting for event\n", timeout);
-		status = timeout;
-	}
-
 	if (timeout == 0) {
 		/* Controller timed out */
 		dev_err(&dev->adev->dev, "read from slave 0x%x timed out\n",
@@ -523,13 +516,6 @@ static int write_i2c(struct nmk_i2c_dev *dev, u16 flags)
 	timeout = wait_for_completion_timeout(
 		&dev->xfer_complete, dev->adap.timeout);
 
-	if (timeout < 0) {
-		dev_err(&dev->adev->dev,
-			"wait_for_completion_timeout "
-			"returned %d waiting for event\n", timeout);
-		status = timeout;
-	}
-
 	if (timeout == 0) {
 		/* Controller timed out */
 		dev_err(&dev->adev->dev, "write to slave 0x%x timed out\n",
-- 
1.7.0.4



