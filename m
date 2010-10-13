Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0JMNpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:45:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35750 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab0JMNph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:45:37 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: khali@linux-fr.org, tony@atomide.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers: i2c-core: Add a flag to allow short timeout
Date: Wed, 13 Oct 2010 16:45:09 +0300
Message-Id: <1286977510-16702-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1286977510-16702-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 13 Oct 2010 13:45:16.0658 (UTC) FILETIME=[DE632520:01CB6ADC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A flag for i2c-messages to allow short time out. Some chips causes
time out always with certain kind of operations (like sw-reset commands).
There is no point of waiting full timeout in that case.
When I2C message is send with I2C_M_SHORT_TIME out flag, adapter is allowed
to use shorter timeout and release the bus faster.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/i2c/i2c-core.c |    2 +-
 include/linux/i2c.h    |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 6649176..8c0e443 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -2077,7 +2077,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
 	int try;
 	s32 res;
 
-	flags &= I2C_M_TEN | I2C_CLIENT_PEC;
+	flags &= I2C_M_TEN | I2C_CLIENT_PEC | I2C_M_SHORT_TIMEOUT;
 
 	if (adapter->algo->smbus_xfer) {
 		i2c_lock_adapter(adapter);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 4bae0b7..5fc016a 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -514,6 +514,7 @@ struct i2c_msg {
 #define I2C_M_IGNORE_NAK	0x1000	/* if I2C_FUNC_PROTOCOL_MANGLING */
 #define I2C_M_NO_RD_ACK		0x0800	/* if I2C_FUNC_PROTOCOL_MANGLING */
 #define I2C_M_RECV_LEN		0x0400	/* length will be first received byte */
+#define I2C_M_SHORT_TIMEOUT	0x0200	/* Use with known timeout cases */
 	__u16 len;		/* msg length				*/
 	__u8 *buf;		/* pointer to msg data			*/
 };
-- 
1.6.0.4

