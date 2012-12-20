Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab2LTPiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 10:38:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44566 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab2LTPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 10:38:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Register MICVDD supply first to ensure no retries
Date: Thu, 20 Dec 2012 15:38:03 +0000
Message-Id: <1356017883-17588-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not strictly required as probe deferral will take care of everything but
it makes boot a little smoother.

Reported-by: Ryo Tsutsui <Ryo.Tsutsui@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index bc8a3ed..a8b8a7b 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -270,19 +270,19 @@ static struct mfd_cell early_devs[] = {
 };
 
 static struct mfd_cell wm5102_devs[] = {
+	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
-	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-pwm" },
 	{ .name = "wm5102-codec" },
 };
 
 static struct mfd_cell wm5110_devs[] = {
+	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-extcon" },
 	{ .name = "arizona-gpio" },
 	{ .name = "arizona-haptics" },
-	{ .name = "arizona-micsupp" },
 	{ .name = "arizona-pwm" },
 	{ .name = "wm5110-codec" },
 };
-- 
1.7.10.4

