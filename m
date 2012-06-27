Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2F0NyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:54:24 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:57872 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2F0NyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:20 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 5/8 v3] i2c: i801: rename some SMBHSTCNT bit constants
Date: Wed, 27 Jun 2012 21:54:12 +0800
Message-Id: <1340805255-8041-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the SMBHSTCNT register bit access constants to match the style of
other register bits.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ba56b74..c57bb0c 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -102,9 +102,6 @@
 #define SMBAUXCTL_CRC		1
 #define SMBAUXCTL_E32B		2
 
-/* kill bit for SMBHSTCNT */
-#define SMBHSTCNT_KILL		2
-
 /* Other settings */
 #define MAX_RETRIES		400
 #define ENABLE_INT9		0	/* set to 0x01 to enable - untested */
@@ -117,9 +114,13 @@
 #define I801_PROC_CALL		0x10	/* unimplemented */
 #define I801_BLOCK_DATA		0x14
 #define I801_I2C_BLOCK_DATA	0x18	/* ICH5 and later */
-#define I801_LAST_BYTE		0x20
-#define I801_START		0x40
-#define I801_PEC_EN		0x80	/* ICH3 and later */
+
+/* I801 Host Control register bits */
+#define SMBHSTCNT_INTREN	0x01
+#define SMBHSTCNT_KILL		0x02
+#define SMBHSTCNT_LAST_BYTE	0x20
+#define SMBHSTCNT_START		0x40
+#define SMBHSTCNT_PEC_EN	0x80	/* ICH3 and later */
 
 /* I801 Hosts Status register bits */
 #define SMBHSTSTS_BYTE_DONE	0x80
@@ -289,7 +290,7 @@ static int i801_transaction(struct i801_priv *priv, int xact)
 
 	/* the current contents of SMBHSTCNT can be overwritten, since PEC,
 	 * INTREN, SMBSCMD are passed in xact */
-	outb_p(xact | I801_START, SMBHSTCNT(priv));
+	outb_p(xact | SMBHSTCNT_START, SMBHSTCNT(priv));
 
 	/* We will always wait for a fraction of a second! */
 	do {
@@ -324,7 +325,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 	}
 
 	status = i801_transaction(priv, I801_BLOCK_DATA | ENABLE_INT9 |
-				  I801_PEC_EN * hwpec);
+				  SMBHSTCNT_PEC_EN * hwpec);
 	if (status)
 		return status;
 
@@ -375,11 +376,11 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 
 	for (i = 1; i <= len; i++) {
 		if (i == len && read_write == I2C_SMBUS_READ)
-			smbcmd |= I801_LAST_BYTE;
+			smbcmd |= SMBHSTCNT_LAST_BYTE;
 		outb_p(smbcmd | ENABLE_INT9, SMBHSTCNT(priv));
 
 		if (i == 1)
-			outb_p(inb(SMBHSTCNT(priv)) | I801_START,
+			outb_p(inb(SMBHSTCNT(priv)) | SMBHSTCNT_START,
 			       SMBHSTCNT(priv));
 
 		/* We will always wait for a fraction of a second! */
-- 
1.7.7.3

