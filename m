Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2ECOkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:40:12 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61204 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767Ab2ECOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:40:09 -0400
From: Emil Goode <emilgoode@gmail.com>
To: mchehab@infradead.org, jareguero@telefonica.net
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] [media] az6007: Fix dubious use of !x & y
Date: Thu,  3 May 2012 16:42:01 +0200
Message-Id: <1336056121-27100-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent here must be to check if the right most bit
of msgs[i].flags is set and then do the logical negation.

Used macro:
#define I2C_M_RD        0x0001

Sparse warns about this:
drivers/media/dvb/dvb-usb/az6007.c:714:40:
	warning: dubious: !x & y

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 4008b9c..0019335a 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -711,7 +711,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		addr = msgs[i].addr << 1;
 		if (((i + 1) < num)
 		    && (msgs[i].len == 1)
-		    && (!msgs[i].flags & I2C_M_RD)
+		    && !(msgs[i].flags & I2C_M_RD)
 		    && (msgs[i + 1].flags & I2C_M_RD)
 		    && (msgs[i].addr == msgs[i + 1].addr)) {
 			/*
-- 
1.7.9.5

