Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0CVHXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:23:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49632 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0CVHXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:23:16 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-i2c@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 4/5] i2c-bfin-twi: remove redundant retry
Date: Mon, 22 Mar 2010 03:23:19 -0400
Message-Id: <1269242600-30147-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
References: <1269242600-30147-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 3495019..d157105 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -357,15 +357,7 @@ static int bfin_twi_do_master_xfer(struct i2c_adapter *adap,
 static int bfin_twi_master_xfer(struct i2c_adapter *adap,
 				struct i2c_msg *msgs, int num)
 {
-	int i, ret = 0;
-
-	for (i = 0; i < adap->retries; i++) {
-		ret = bfin_twi_do_master_xfer(adap, msgs, num);
-		if (ret > 0)
-			break;
-	}
-
-	return ret;
+	return bfin_twi_do_master_xfer(adap, msgs, num);
 }
 
 /*
@@ -573,16 +565,8 @@ int bfin_twi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
 			unsigned short flags, char read_write,
 			u8 command, int size, union i2c_smbus_data *data)
 {
-	int i, ret = 0;
-
-	for (i = 0; i < adap->retries; i++) {
-		ret = bfin_twi_do_smbus_xfer(adap, addr, flags,
+	return bfin_twi_do_smbus_xfer(adap, addr, flags,
 			read_write, command, size, data);
-		if (ret == 0)
-			break;
-	}
-
-	return ret;
 }
 
 /*
-- 
1.7.0.2

