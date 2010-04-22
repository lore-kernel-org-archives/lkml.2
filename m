Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0DVWDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:03:17 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45758 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0DVWDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:03:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=r6uL3uES9vYf8wBBvYHNkZGs9P+koOlIQF1udK8mM4rM8AsBLbDThPnNTlv29LrDry
         tWjFYtJJOpND/0On/VF22abfyKg7uOimpQDilhePV40aq18Sl1OEHLzNuHychimUODdq
         tmN4oQAszQ/RZ47yfCgVh5Go6COabZoau9RWw=
From: Farid Hammane <farid.hammane@gmail.com>
To: w.sang@pengutronix.de
Cc: khali@linux-fr.org, ben-linux@fluff.org, Enrik.Berkhan@ge.com,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Farid Hammane <farid.hammane@gmail.com>
Subject: [PATCH V2] i2c-algo-pca: fix coding style issues in i2c-algo-pca.c
Date: Fri, 23 Apr 2010 00:01:55 +0200
Message-Id: <1271973715-18331-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coding style issues found by checkpatch.pl.
i2c-algo-pca.c has been built successfully after applying this patch.

Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
---
 drivers/i2c/algos/i2c-algo-pca.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
index dcdaf8e..ca817f8 100644
--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -37,15 +37,15 @@
 
 static int i2c_debug;
 
-#define pca_outw(adap, reg, val) adap->write_byte(adap->data, reg, val)
-#define pca_inw(adap, reg) adap->read_byte(adap->data, reg)
+#define pca_outw(adap, reg, val) (adap->write_byte(adap->data, reg, val))
+#define pca_inw(adap, reg) (adap->read_byte(adap->data, reg))
 
 #define pca_status(adap) pca_inw(adap, I2C_PCA_STA)
-#define pca_clock(adap) adap->i2c_clock
+#define pca_clock(adap) (adap->i2c_clock)
 #define pca_set_con(adap, val) pca_outw(adap, I2C_PCA_CON, val)
 #define pca_get_con(adap) pca_inw(adap, I2C_PCA_CON)
-#define pca_wait(adap) adap->wait_for_completion(adap->data)
-#define pca_reset(adap) adap->reset_chip(adap->data)
+#define pca_wait(adap) (adap->wait_for_completion(adap->data))
+#define pca_reset(adap) (adap->reset_chip(adap->data))
 
 static void pca9665_reset(void *pd)
 {
@@ -114,8 +114,8 @@ static int pca_address(struct i2c_algo_pca_data *adap,
 	int sta = pca_get_con(adap);
 	int addr;
 
-	addr = ( (0x7f & msg->addr) << 1 );
-	if (msg->flags & I2C_M_RD )
+	addr = ((0x7f & msg->addr) << 1);
+	if (msg->flags & I2C_M_RD)
 		addr |= 1;
 	DEB2("=== SLAVE ADDRESS %#04x+%c=%#04x\n",
 	     msg->addr, msg->flags & I2C_M_RD ? 'R' : 'W', addr);
@@ -170,7 +170,7 @@ static int pca_rx_ack(struct i2c_algo_pca_data *adap,
 
 	sta &= ~(I2C_PCA_CON_STO|I2C_PCA_CON_STA|I2C_PCA_CON_SI|I2C_PCA_CON_AA);
 
-	if ( ack )
+	if (ack)
 		sta |= I2C_PCA_CON_AA;
 
 	pca_set_con(adap, sta);
@@ -181,9 +181,9 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
                     struct i2c_msg *msgs,
                     int num)
 {
-        struct i2c_algo_pca_data *adap = i2c_adap->algo_data;
-        struct i2c_msg *msg = NULL;
-        int curmsg;
+	struct i2c_algo_pca_data *adap = i2c_adap->algo_data;
+	struct i2c_msg *msg = NULL;
+	int curmsg;
 	int numbytes = 0;
 	int state;
 	int ret;
@@ -202,21 +202,21 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 
 	DEB1("{{{ XFER %d messages\n", num);
 
-	if (i2c_debug>=2) {
+	if (i2c_debug >= 2) {
 		for (curmsg = 0; curmsg < num; curmsg++) {
 			int addr, i;
 			msg = &msgs[curmsg];
 
 			addr = (0x7f & msg->addr) ;
 
-			if (msg->flags & I2C_M_RD )
+			if (msg->flags & I2C_M_RD)
 				printk(KERN_INFO "    [%02d] RD %d bytes from %#02x [%#02x, ...]\n",
-				       curmsg, msg->len, addr, (addr<<1) | 1);
+				       curmsg, msg->len, addr, (addr << 1) | 1);
 			else {
 				printk(KERN_INFO "    [%02d] WR %d bytes to %#02x [%#02x%s",
-				       curmsg, msg->len, addr, addr<<1,
+				       curmsg, msg->len, addr, addr << 1,
 				       msg->len == 0 ? "" : ", ");
-				for(i=0; i < msg->len; i++)
+				for (i = 0; i < msg->len; i++)
 					printk("%#04x%s", msg->buf[i], i == msg->len - 1 ? "" : ", ");
 				printk("]\n");
 			}
@@ -305,7 +305,7 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 			goto out;
 
 		case 0x58: /* Data byte has been received; NOT ACK has been returned */
-			if ( numbytes == msg->len - 1 ) {
+			if (numbytes == msg->len - 1) {
 				pca_rx_byte(adap, &msg->buf[numbytes], 0);
 				curmsg++; numbytes = 0;
 				if (curmsg == num)
@@ -352,7 +352,7 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 
 static u32 pca_func(struct i2c_adapter *adap)
 {
-        return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 static const struct i2c_algorithm pca_algo = {
-- 
1.7.0

