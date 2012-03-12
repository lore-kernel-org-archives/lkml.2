Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2CLXPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:15:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2CLXPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:15:32 -0400
Message-ID: <1331594127.5392.3.camel@phoenix>
Subject: [PATCH] regulator: Fix the logic of tps65910_get_mode
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 13 Mar 2012 07:15:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We actually clear LDO_ST_ON_BIT for standby mode in tps65910_set_mode.
Fix the logic in tps65910_get_mode.

Supply state (EEPROM bits):
ST[1:0] = 00 : Off
ST[1:0] = 01 : On high power (ACTIVE)
ST[1:0] = 10 : Off
ST[1:0] = 11 : On low power (SLEEP)

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65910-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 8074d51..33904e7 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -520,7 +520,7 @@ static unsigned int tps65910_get_mode(struct regulator_dev *dev)
 	if (value < 0)
 		return value;
 
-	if (value & LDO_ST_ON_BIT)
+	if (!(value & LDO_ST_ON_BIT))
 		return REGULATOR_MODE_STANDBY;
 	else if (value & LDO_ST_MODE_BIT)
 		return REGULATOR_MODE_IDLE;
-- 
1.7.5.4



