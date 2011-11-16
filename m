Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1KPLw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:52:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42744 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124Ab1KPLw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:52:27 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] watchdog: Don't overwrite error value in wm831x_wdt_set_timeout()
Date: Wed, 16 Nov 2011 11:52:12 +0000
Message-Id: <1321444332-304-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/watchdog/wm831x_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/wm831x_wdt.c b/drivers/watchdog/wm831x_wdt.c
index 7be3855..e789a47 100644
--- a/drivers/watchdog/wm831x_wdt.c
+++ b/drivers/watchdog/wm831x_wdt.c
@@ -150,7 +150,7 @@ static int wm831x_wdt_set_timeout(struct watchdog_device *wdt_dev,
 		if (wm831x_wdt_cfgs[i].time == timeout)
 			break;
 	if (i == ARRAY_SIZE(wm831x_wdt_cfgs))
-		ret = -EINVAL;
+		return -EINVAL;
 
 	ret = wm831x_reg_unlock(wm831x);
 	if (ret == 0) {
-- 
1.7.7.2

