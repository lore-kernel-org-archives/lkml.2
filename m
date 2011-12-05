Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab1LEMBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:01:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37253 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103Ab1LEMBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:01:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Return an error on failed wm831x register writes
Date: Mon,  5 Dec 2011 12:01:07 +0000
Message-Id: <1323086467-1222-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got dropped in the regmap conversion.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 3b76189..f5e54fa 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -559,6 +559,8 @@ static int wm831x_write(struct wm831x *wm831x, unsigned short reg,
 		dev_vdbg(wm831x->dev, "Write %04x to R%d(0x%x)\n",
 			 buf[i], reg + i, reg + i);
 		ret = regmap_write(wm831x->regmap, reg + i, buf[i]);
+		if (ret != 0)
+			return ret;
 	}
 
 	return 0;
-- 
1.7.7.3

