Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2FLIg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:36:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65357 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2FLIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:36:26 -0400
Message-ID: <1339490180.6743.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: wm8400: Adjust the equation for selector >=
 15 in wm8400_ldo_list_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 12 Jun 2012 16:36:20 +0800
In-Reply-To: <1339490095.6743.1.camel@phoenix>
References: <1339490095.6743.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust the equation for selector >= 15 for better readability.
The equation "1700000 + ((selector - 15) * 100000)" can be interpreted by:
Starting from selector 15: Steps of 100mV from 1700mV

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8400-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 9f9df8e..9035dd0 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -28,7 +28,7 @@ static int wm8400_ldo_list_voltage(struct regulator_dev *dev,
 	if (selector < 15)
 		return 900000 + (selector * 50000);
 	else
-		return 1600000 + ((selector - 14) * 100000);
+		return 1700000 + ((selector - 15) * 100000);
 }
 
 static int wm8400_ldo_map_voltage(struct regulator_dev *dev,
-- 
1.7.9.5



