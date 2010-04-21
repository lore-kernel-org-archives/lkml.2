Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0DUTOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 15:14:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44854 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab0DUTOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 15:14:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s21AnIA3Mc1N5PdfFj7th7OWVkoOhn+vXq1/5TGYrZPtxwV5MEsExDXC14suqymncB
         UXv0zxuabVIC3yZg+7UoC+3VIxWpwIJYNBME3NvYRWaoERBulbab+coJ+emg0ww/elRs
         xczut23P06gtlT41tnHDal9rUX6VYi28YLHOY=
From: Farid Hammane <farid.hammane@gmail.com>
To: khali@linux-fr.org
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, Enrik.Berkhan@ge.com,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Farid Hammane <farid.hammane@gmail.com>
Subject: [PATCH] i2c-algo-pca: fix all coding style issues in i2c-algo-pca.c
Date: Wed, 21 Apr 2010 21:11:37 +0200
Message-Id: <1271877097-10939-1-git-send-email-farid.hammane@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all coding style issues found by checkpatch.pl.

Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
---
 drivers/i2c/algos/i2c-algo-pca.c |   74 ++++++++++++++++++++++---------------
 1 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
index dcdaf8e..4cb9ece 100644
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
@@ -178,12 +178,12 @@ static int pca_rx_ack(struct i2c_algo_pca_data *adap,
 }
 
 static int pca_xfer(struct i2c_adapter *i2c_adap,
-                    struct i2c_msg *msgs,
-                    int num)
+		struct i2c_msg *msgs,
+		int num)
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
@@ -202,22 +202,25 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 
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
 				       curmsg, msg->len, addr, (addr<<1) | 1);
 			else {
 				printk(KERN_INFO "    [%02d] WR %d bytes to %#02x [%#02x%s",
 				       curmsg, msg->len, addr, addr<<1,
 				       msg->len == 0 ? "" : ", ");
-				for(i=0; i < msg->len; i++)
-					printk("%#04x%s", msg->buf[i], i == msg->len - 1 ? "" : ", ");
+				for (i = 0; i < msg->len; i++)
+					printk("%#04x%s",
+							msg->buf[i],
+							i == msg->len - 1 ?
+							"" : ", ");
 				printk("]\n");
 			}
 		}
@@ -241,8 +244,10 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 			completed = pca_address(adap, msg);
 			break;
 
-		case 0x18: /* SLA+W has been transmitted; ACK has been received */
-		case 0x28: /* Data byte in I2CDAT has been transmitted; ACK has been received */
+		case 0x18: /* SLA+W has been transmitted;
+			      ACK has been received */
+		case 0x28: /* Data byte in I2CDAT has been transmitted;
+			      ACK has been received */
 			if (numbytes < msg->len) {
 				completed = pca_tx_byte(adap,
 							msg->buf[numbytes]);
@@ -256,16 +261,19 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 				completed = pca_repeated_start(adap);
 			break;
 
-		case 0x20: /* SLA+W has been transmitted; NOT ACK has been received */
+		case 0x20: /* SLA+W has been transmitted;
+			      NOT ACK has been received */
 			DEB2("NOT ACK received after SLA+W\n");
 			pca_stop(adap);
 			goto out;
 
-		case 0x40: /* SLA+R has been transmitted; ACK has been received */
+		case 0x40: /* SLA+R has been transmitted;
+			      ACK has been received */
 			completed = pca_rx_ack(adap, msg->len > 1);
 			break;
 
-		case 0x50: /* Data bytes has been received; ACK has been returned */
+		case 0x50: /* Data bytes has been received;
+			      ACK has been returned */
 			if (numbytes < msg->len) {
 				pca_rx_byte(adap, &msg->buf[numbytes], 1);
 				numbytes++;
@@ -280,17 +288,20 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 				completed = pca_repeated_start(adap);
 			break;
 
-		case 0x48: /* SLA+R has been transmitted; NOT ACK has been received */
+		case 0x48: /* SLA+R has been transmitted;
+			      NOT ACK has been received */
 			DEB2("NOT ACK received after SLA+R\n");
 			pca_stop(adap);
 			goto out;
 
-		case 0x30: /* Data byte in I2CDAT has been transmitted; NOT ACK has been received */
+		case 0x30: /* Data byte in I2CDAT has been transmitted;
+			      NOT ACK has been received */
 			DEB2("NOT ACK received after data byte\n");
 			pca_stop(adap);
 			goto out;
 
-		case 0x38: /* Arbitration lost during SLA+W, SLA+R or data bytes */
+		case 0x38: /* Arbitration lost during SLA+W, SLA+R or
+			      data bytes */
 			DEB2("Arbitration lost\n");
 			/*
 			 * The PCA9564 data sheet (2006-09-01) says "A
@@ -304,8 +315,9 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 			pca_start(adap);
 			goto out;
 
-		case 0x58: /* Data byte has been received; NOT ACK has been returned */
-			if ( numbytes == msg->len - 1 ) {
+		case 0x58: /* Data byte has been received;
+			      NOT ACK has been returned */
+			if (numbytes == msg->len - 1) {
 				pca_rx_byte(adap, &msg->buf[numbytes], 0);
 				curmsg++; numbytes = 0;
 				if (curmsg == num)
@@ -328,12 +340,14 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 			DEB2("BUS ERROR - SCL Stuck low\n");
 			pca_reset(adap);
 			goto out;
-		case 0x00: /* Bus error during master or slave mode due to illegal START or STOP condition */
+		case 0x00: /* Bus error during master or slave mode
+			      due to illegal START or STOP condition */
 			DEB2("BUS ERROR - Illegal START or STOP\n");
 			pca_reset(adap);
 			goto out;
 		default:
-			dev_err(&i2c_adap->dev, "unhandled SIO state 0x%02x\n", state);
+			dev_err(&i2c_adap->dev, "unhandled SIO state 0x%02x\n",
+					state);
 			break;
 		}
 
@@ -352,7 +366,7 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
 
 static u32 pca_func(struct i2c_adapter *adap)
 {
-        return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
 }
 
 static const struct i2c_algorithm pca_algo = {
-- 
1.7.0

