Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2K1TET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:04:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54185 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755227Ab2K1TES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:04:18 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Mark DSP memory regions as volatile
Date: Wed, 28 Nov 2012 19:04:16 +0000
Message-Id: <1354129456-27129-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can cache some of them but this is simpler for now.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 065ffd3..965e60f 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1832,6 +1832,9 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 
 static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 {
+	if (reg > 0xffff)
+		return true;
+
 	switch (reg) {
 	case ARIZONA_SOFTWARE_RESET:
 	case ARIZONA_DEVICE_REVISION:
-- 
1.7.10.4

