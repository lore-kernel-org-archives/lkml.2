Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2CLCSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:18:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42718 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2CLCSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:18:01 -0400
Message-ID: <1331518676.2558.5.camel@phoenix>
Subject: [PATCH] regulator: Use DIV_ROUND_CLOSEST in wm8350_isink_get_current
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 12 Mar 2012 10:17:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DIV_ROUND_CLOSEST performs the computation (x + d/2)/d with better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8350-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 4f46067..ab1e183 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -186,7 +186,7 @@ static int wm8350_isink_get_current(struct regulator_dev *rdev)
 		return 0;
 	}
 
-	return (isink_cur[val] + 50) / 100;
+	return DIV_ROUND_CLOSEST(isink_cur[val], 100);
 }
 
 /* turn on ISINK followed by DCDC */
-- 
1.7.5.4



