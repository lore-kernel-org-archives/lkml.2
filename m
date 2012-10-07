Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2JGPjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:39:25 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3043 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750845Ab2JGPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:39:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="158166837"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, rmallon@gmail.com, shubhrajyoti@ti.com
Subject: [PATCH 1/13] include/linux/i2c.h: introduce macros for i2c_msg initialization
Date: Sun,  7 Oct 2012 17:38:31 +0200
Message-Id: <1349624323-15584-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

This patch introduces some macros for describing how an i2c_msg is being
initialized.  There are three macros: I2C_MSG_READ, for a read message,
I2C_MSG_WRITE, for a write message, and I2C_MSG_OP, for some other kind of
message, which is expected to be very rarely used.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 include/linux/i2c.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 94aed0c..885ebea 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -556,6 +556,12 @@ struct i2c_msg {
 	__u8 *buf;		/* pointer to msg data			*/
 };
 
+#define I2C_MSG_OP(_addr, _buf, _len, _flags) \
+	{ .addr = _addr, .buf = _buf, .len = _len, .flags = _flags }
+
+#define I2C_MSG_WRITE(addr, buf, len) I2C_MSG_OP(addr, buf, len, 0)
+#define I2C_MSG_READ(addr, buf, len)  I2C_MSG_OP(addr, buf, len, I2C_M_RD)
+
 /* To determine what functionality is present */
 
 #define I2C_FUNC_I2C			0x00000001
