Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0EIKMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 06:12:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52871 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0EIKMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 06:12:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 2/6] ad525x_dpot: extend write argument to 16bits
Date: Sun,  9 May 2010 06:15:25 -0400
Message-Id: <1273400129-26101-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273400129-26101-1-git-send-email-vapier@gentoo.org>
References: <1273400129-26101-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The possible output data is 16bits, not 8bits, so don't truncate it.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/ad525x_dpot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index e6b274b..ce92088 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -75,7 +75,7 @@ enum dpot_devid {
 #define AD525X_INC_ALL		(AD525X_I2C_CMD | (0xB << 3))
 
 static s32 ad525x_read(struct i2c_client *client, u8 reg);
-static s32 ad525x_write(struct i2c_client *client, u8 reg, u8 value);
+static s32 ad525x_write(struct i2c_client *client, u8 reg, u16 value);
 
 /*
  * Client data (each client gets its own)
@@ -296,7 +296,7 @@ static s32 ad525x_read(struct i2c_client *client, u8 reg)
  * A negative return value indicates an error occurred while reading
  * the register.
  */
-static s32 ad525x_write(struct i2c_client *client, u8 reg, u8 value)
+static s32 ad525x_write(struct i2c_client *client, u8 reg, u16 value)
 {
 	struct dpot_data *data = i2c_get_clientdata(client);
 
-- 
1.7.1

