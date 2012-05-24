Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2EXI5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:57:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61865 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2EXI5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:57:52 -0400
Message-ID: <1337849866.1028.1.camel@phoenix>
Subject: [PATCH 2/2] mfd: max77693: Remove unused iolock mutex
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 24 May 2012 16:57:46 +0800
In-Reply-To: <1337849788.1028.0.camel@phoenix>
References: <1337849788.1028.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now this driver is using regmap APIs, the iolock mutex is not used and can be
removed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max77693.c               |    2 --
 include/linux/mfd/max77693-private.h |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index e9e4278..4055bc2 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -138,8 +138,6 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 
 	max77693->wakeup = pdata->wakeup;
 
-	mutex_init(&max77693->iolock);
-
 	if (max77693_read_reg(max77693->regmap,
 				MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {
 		dev_err(max77693->dev, "device not found on this channel\n");
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 68263c5..1eeae5c 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -190,7 +190,6 @@ struct max77693_dev {
 	struct i2c_client *i2c;		/* 0xCC , PMIC, Charger, Flash LED */
 	struct i2c_client *muic;	/* 0x4A , MUIC */
 	struct i2c_client *haptic;	/* 0x90 , Haptic */
-	struct mutex iolock;
 
 	int type;
 
-- 
1.7.5.4



