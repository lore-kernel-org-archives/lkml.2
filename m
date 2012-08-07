Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2HGTBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:01:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38692 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2HGTBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:01:43 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH v2] regulator: make the dummy regulator's print_constraint more helpful
Date: Tue,  7 Aug 2012 21:01:37 +0200
Message-Id: <1344366097-23775-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120807181642.GF16861@opensource.wolfsonmicro.com>
References: <20120807181642.GF16861@opensource.wolfsonmicro.com>
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

in the boot log. Now it says:

	regulator-dummy: no parameters

which at least doesn't make it look like an accidental printk and also doesn't
only use "dummy" which could mean anything.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/regulator/core.c  |    3 +++
 drivers/regulator/dummy.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8b4b382..1ca21cb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -808,6 +808,9 @@ static void print_constraints(struct regulator_dev *rdev)
 	if (constraints->valid_modes_mask & REGULATOR_MODE_STANDBY)
 		count += sprintf(buf + count, "standby");
 
+	if (!count)
+		sprintf(buf, "no parameters");
+
 	rdev_info(rdev, "%s\n", buf);
 
 	if ((constraints->min_uV != constraints->max_uV) &&
diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
index 86f655c..03a1d7c 100644
--- a/drivers/regulator/dummy.c
+++ b/drivers/regulator/dummy.c
@@ -30,7 +30,7 @@ static struct regulator_init_data dummy_initdata;
 static struct regulator_ops dummy_ops;
 
 static struct regulator_desc dummy_desc = {
-	.name = "dummy",
+	.name = "regulator-dummy",
 	.id = -1,
 	.type = REGULATOR_VOLTAGE,
 	.owner = THIS_MODULE,
-- 
1.7.10.4

