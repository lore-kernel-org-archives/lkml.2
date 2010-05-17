Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0EQOla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:41:30 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:59867 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab0EQOl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:41:29 -0400
X-Greylist: delayed 1835 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 10:41:28 EDT
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-kernel@vger.kernel.org>
Cc: <STEricsson_nomadik_linux@list.st.com>,
       Sundar R Iyer <sundar.iyer@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/1] regulator: return set_mode is same mode is requested
Date: Mon, 17 May 2010 19:39:53 +0530
Message-ID: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sundar R Iyer <sundar.iyer@stericsson.com>

Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
---
 drivers/regulator/core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 98e5d14..5054add 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1599,6 +1599,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 {
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
+	int regulator_curr_mode;
 
 	mutex_lock(&rdev->mutex);
 
@@ -1754,6 +1755,13 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 		goto out;
 	}
 
+	/* return if the same mode is requested */
+	regulator_curr_mode = rdev->desc->ops->get_mode(rdev);
+	if (regulator_curr_mode == mode) {
+		ret = 0;
+		goto out;
+	}
+
 	/* constraints check */
 	ret = regulator_check_mode(rdev, mode);
 	if (ret < 0)
-- 
1.7.0

