Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab0JZCpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:45:10 -0400
Received: from mail.perches.com ([173.55.12.10]:3561 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757992Ab0JZCoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] drivers/media: Removed unnecessary KERN_<level>s from dprintk uses
Date: Mon, 25 Oct 2010 19:44:25 -0700
Message-Id: <970cb8e439723953f9b44b564dab3b03b311dbfd.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converted if (debug >= 2) printk(KERN_DEBUG... to if debug >= 2) dprintk(...)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/common/tuners/max2165.c         |   10 ++++------
 drivers/media/dvb/frontends/atbm8830.c        |    8 +++-----
 drivers/media/dvb/frontends/lgs8gxx.c         |   11 ++++-------
 drivers/media/video/saa7134/saa7134-input.c   |    2 +-
 drivers/media/video/saa7134/saa7134-tvaudio.c |   12 ++++++------
 5 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/media/common/tuners/max2165.c b/drivers/media/common/tuners/max2165.c
index 937e4b0..9883617 100644
--- a/drivers/media/common/tuners/max2165.c
+++ b/drivers/media/common/tuners/max2165.c
@@ -52,13 +52,12 @@ static int max2165_write_reg(struct max2165_priv *priv, u8 reg, u8 data)
 	msg.addr = priv->config->i2c_address;
 
 	if (debug >= 2)
-		printk(KERN_DEBUG "%s: reg=0x%02X, data=0x%02X\n",
-			__func__, reg, data);
+		dprintk("%s: reg=0x%02X, data=0x%02X\n", __func__, reg, data);
 
 	ret = i2c_transfer(priv->i2c, &msg, 1);
 
 	if (ret != 1)
-		dprintk(KERN_DEBUG "%s: error reg=0x%x, data=0x%x, ret=%i\n",
+		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",
 			__func__, reg, data, ret);
 
 	return (ret != 1) ? -EIO : 0;
@@ -78,14 +77,13 @@ static int max2165_read_reg(struct max2165_priv *priv, u8 reg, u8 *p_data)
 
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret != 2) {
-		dprintk(KERN_DEBUG "%s: error reg=0x%x, ret=%i\n",
-			__func__, reg, ret);
+		dprintk("%s: error reg=0x%x, ret=%i\n", __func__, reg, ret);
 		return -EIO;
 	}
 
 	*p_data = b1[0];
 	if (debug >= 2)
-		printk(KERN_DEBUG "%s: reg=0x%02X, data=0x%02X\n",
+		dprintk("%s: reg=0x%02X, data=0x%02X\n",
 			__func__, reg, b1[0]);
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index 43aac2f..1539ea1 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -50,8 +50,7 @@ static int atbm8830_write_reg(struct atbm_state *priv, u16 reg, u8 data)
 	msg2.addr = dev_addr;
 
 	if (debug >= 2)
-		printk(KERN_DEBUG "%s: reg=0x%04X, data=0x%02X\n",
-			__func__, reg, data);
+		dprintk("%s: reg=0x%04X, data=0x%02X\n", __func__, reg, data);
 
 	ret = i2c_transfer(priv->i2c, &msg1, 1);
 	if (ret != 1)
@@ -77,8 +76,7 @@ static int atbm8830_read_reg(struct atbm_state *priv, u16 reg, u8 *p_data)
 
 	ret = i2c_transfer(priv->i2c, &msg1, 1);
 	if (ret != 1) {
-		dprintk(KERN_DEBUG "%s: error reg=0x%04x, ret=%i\n",
-			__func__, reg, ret);
+		dprintk("%s: error reg=0x%04x, ret=%i\n", __func__, reg, ret);
 		return -EIO;
 	}
 
@@ -88,7 +86,7 @@ static int atbm8830_read_reg(struct atbm_state *priv, u16 reg, u8 *p_data)
 
 	*p_data = buf2[0];
 	if (debug >= 2)
-		printk(KERN_DEBUG "%s: reg=0x%04X, data=0x%02X\n",
+		dprintk("%s: reg=0x%04X, data=0x%02X\n",
 			__func__, reg, buf2[0]);
 
 	return 0;
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index 5ea28ae..8989f8f 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -60,13 +60,12 @@ static int lgs8gxx_write_reg(struct lgs8gxx_state *priv, u8 reg, u8 data)
 		msg.addr += 0x02;
 
 	if (debug >= 2)
-		printk(KERN_DEBUG "%s: reg=0x%02X, data=0x%02X\n",
-			__func__, reg, data);
+		dprintk("%s: reg=0x%02X, data=0x%02X\n", __func__, reg, data);
 
 	ret = i2c_transfer(priv->i2c, &msg, 1);
 
 	if (ret != 1)
-		dprintk(KERN_DEBUG "%s: error reg=0x%x, data=0x%x, ret=%i\n",
+		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",
 			__func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
@@ -91,15 +90,13 @@ static int lgs8gxx_read_reg(struct lgs8gxx_state *priv, u8 reg, u8 *p_data)
 
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret != 2) {
-		dprintk(KERN_DEBUG "%s: error reg=0x%x, ret=%i\n",
-			__func__, reg, ret);
+		dprintk("%s: error reg=0x%x, ret=%i\n", __func__, reg, ret);
 		return -1;
 	}
 
 	*p_data = b1[0];
 	if (debug >= 2)
-		printk(KERN_DEBUG "%s: reg=0x%02X, data=0x%02X\n",
-			__func__, reg, b1[0]);
+		dprintk("%s: reg=0x%02X, data=0x%02X\n", __func__, reg, b1[0]);
 	return 0;
 }
 
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 0b336ca..f81a19f 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -965,7 +965,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 		   an existing device. Weird...
 		   REVISIT: might no longer be needed */
 		rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
-		dprintk(KERN_DEBUG "probe 0x%02x @ %s: %s\n",
+		dprintk("probe 0x%02x @ %s: %s\n",
 			msg_msi.addr, dev->i2c_adap.name,
 			(1 == rc) ? "yes" : "no");
 		break;
diff --git a/drivers/media/video/saa7134/saa7134-tvaudio.c b/drivers/media/video/saa7134/saa7134-tvaudio.c
index 3e7d2fd..57e646b 100644
--- a/drivers/media/video/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/video/saa7134/saa7134-tvaudio.c
@@ -550,16 +550,16 @@ static int tvaudio_thread(void *data)
 		} else if (0 != dev->last_carrier) {
 			/* no carrier -- try last detected one as fallback */
 			carrier = dev->last_carrier;
-			dprintk(KERN_WARNING "%s/audio: audio carrier scan failed, "
-			       "using %d.%03d MHz [last detected]\n",
-			       dev->name, carrier/1000, carrier%1000);
+			dprintk("audio carrier scan failed, "
+				"using %d.%03d MHz [last detected]\n",
+				carrier/1000, carrier%1000);
 
 		} else {
 			/* no carrier + no fallback -- use default */
 			carrier = default_carrier;
-			dprintk(KERN_WARNING "%s/audio: audio carrier scan failed, "
-			       "using %d.%03d MHz [default]\n",
-			       dev->name, carrier/1000, carrier%1000);
+			dprintk("audio carrier scan failed, "
+				"using %d.%03d MHz [default]\n",
+				carrier/1000, carrier%1000);
 		}
 		tvaudio_setcarrier(dev,carrier,carrier);
 		dev->automute = 0;
-- 
1.7.3.dirty

