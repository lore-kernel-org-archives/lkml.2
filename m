Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2EUBjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 21:39:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2EUBjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 21:39:14 -0400
Message-ID: <1337564348.4772.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: ab8500: Let regulator core handle the case
 no delay for setting new voltage if regulator is off
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 21 May 2012 09:39:08 +0800
In-Reply-To: <1337564272.4772.2.camel@phoenix>
References: <1337564272.4772.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab8500.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index da883e6..f158074 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -256,14 +256,7 @@ static int ab8500_regulator_set_voltage_time_sel(struct regulator_dev *rdev,
 					     unsigned int new_sel)
 {
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
-	int ret;
 
-	/* If the regulator isn't on, it won't take time here */
-	ret = ab8500_regulator_is_enabled(rdev);
-	if (ret < 0)
-		return ret;
-	if (!ret)
-		return 0;
 	return info->delay;
 }
 
-- 
1.7.5.4



