Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1KGKVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:21:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:65107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab1KGKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:21:21 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: lm63: Add support for the NatSemi LM96163.
Date: Mon,  7 Nov 2011 11:20:58 +0100
Message-Id: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.7.2
X-Provags-ID: V02:K0:RSBO9Q2sVvJcu1PLgH0k7HCGoVm4zBXxdPQEy07DeOe
 KGjLzTHFOtiKcwDw3dnrlpp5D7bT4220E9SrHRH3eFWzEMTh87
 sfAn+6L/DNQ/zCsXOLwBV0sRe01d8/0rl/oM9qZRtiqiC2HlJ4
 S1DEoWczwLU9M8m3hQVwbJQRxv4WLr5zzuaPcrPazq1n/X0joJ
 7bDRlDF9N6XI7uo6I6Y/taxHuIW2gGspNmv5+DNqdaJLuU5KkF
 owVZT0diP2jn6DZVSDTv5kmtXOBqjMcq8d1wRdSaROyhhZ3SVY
 HYosHfNWJKRsy0csvfDWrmZm21EMHTGfT3umf25X3gmqpBzWQj
 XfqaMZckCQA1iPnU5FH4/0TaPXGaDPEcaxi103F6h10PHD1ELR
 DRDeZTyOp4zu4fsJprLEeMiqd5ni3jQlbVckbSQMkiYyF70Z2d
 Sk/sb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/hwmon/lm63.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index 508cb29..94e373c 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -483,7 +483,7 @@ static int lm63_detect(struct i2c_client *new_client,
 		return -ENODEV;
 	}
 
-	if (chip_id == 0x41 && address == 0x4c)
+	if ((chip_id == 0x41 || chip_id == 0x49) && address == 0x4c)
 		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
 	else if (chip_id == 0x51 && (address == 0x18 || address == 0x4e))
 		strlcpy(info->type, "lm64", I2C_NAME_SIZE);
-- 
1.7.7.2

