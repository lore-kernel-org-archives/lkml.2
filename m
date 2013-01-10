Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3AJMVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:21:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41518 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab3AJMS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:58 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/9] mfd: arizona: Register MICVDD supply first to ensure no retries
Date: Thu, 10 Jan 2013 12:18:46 +0000
Message-Id: <1357820332-14586-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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

