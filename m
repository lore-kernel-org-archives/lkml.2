Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2HFJSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:18:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59230 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2HFJSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:18:46 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH RFC] regulator: suppress printk if there is no real info
Date: Mon,  6 Aug 2012 11:18:40 +0200
Message-Id: <1344244720-24051-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents the output of just

	dummy:

in the boot log.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

probably this really only applies to the dummy regulator. If not it
might be more sensible to do:

	if (!buf[0])
		buf = "no parameters";

or similar. Other than that I wonder if setting the devicename from
"dummy" to say "regulator-dummy" would be an improvement, too.

Best regards
Uwe

 drivers/regulator/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8b4b382..9275259 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -808,7 +808,8 @@ static void print_constraints(struct regulator_dev *rdev)
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
 		count += sprintf(buf + count, "standby");
 
-	rdev_info(rdev, "%s\n", buf);
+	if (buf[0])
+		rdev_info(rdev, "%s\n", buf);
 
 	if ((constraints->min_uV != constraints->max_uV) &&
 	    !(constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE))
-- 
1.7.10.4

