Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0JVL5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:57:51 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:30013 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab0JVL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:49 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] hwmon: lis3: restore axis enabled bits
Date: Fri, 22 Oct 2010 14:57:28 +0300
Message-Id: <1287748654-2626-7-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All axis enable bits are set to 0 at module remove.
Restore reset default value at init.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d_i2c.c |    2 +-
 drivers/hwmon/lis3lv02d_spi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
index 98983cc..36171bf 100644
--- a/drivers/hwmon/lis3lv02d_i2c.c
+++ b/drivers/hwmon/lis3lv02d_i2c.c
@@ -83,7 +83,7 @@ static int lis3_i2c_init(struct lis3lv02d *lis3)
 	if (ret < 0)
 		return ret;
 
-	reg |= CTRL1_PD0;
+	reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
 	return lis3->write(lis3, CTRL_REG1, reg);
 }
 
diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index b9be5e3..778885d 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -50,7 +50,7 @@ static int lis3_spi_init(struct lis3lv02d *lis3)
 	if (ret < 0)
 		return ret;
 
-	reg |= CTRL1_PD0;
+	reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
 	return lis3->write(lis3, CTRL_REG1, reg);
 }
 
-- 
1.6.0.4

