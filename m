Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab2KDUlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 15:41:00 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37193 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2KDUk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 15:40:57 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/media: Use dev_ printks in go7007/wis-sony-tuner.c
Date: Mon,  5 Nov 2012 05:40:51 +0900
Message-Id: <1352061652-5937-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/wis-sony-tuner.c |   86 ++++++++++++-------------
 1 file changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/media/go7007/wis-sony-tuner.c b/drivers/staging/media/go7007/wis-sony-tuner.c
index 8f1b7d4..3e013b9 100644
--- a/drivers/staging/media/go7007/wis-sony-tuner.c
+++ b/drivers/staging/media/go7007/wis-sony-tuner.c
@@ -95,8 +95,8 @@ static int set_freq(struct i2c_client *client, int freq)
 		band_name = "UHF";
 		band_select = tun->UHF;
 	}
-	printk(KERN_DEBUG "wis-sony-tuner: tuning to frequency %d.%04d (%s)\n",
-			freq / 16, (freq % 16) * 625, band_name);
+	dev_dbg(&client->dev, "tuning to frequency %d.%04d (%s)\n",
+		freq / 16, (freq % 16) * 625, band_name);
 	n = freq + tun->IFPCoff;
 
 	buffer[0] = n >> 8;
@@ -288,16 +288,16 @@ static int mpx_setup(struct i2c_client *client)
 		u8 buf1[3], buf2[2];
 		struct i2c_msg msgs[2];
 
-		printk(KERN_DEBUG "wis-sony-tuner: MPX registers: %04x %04x "
-				"%04x %04x %04x %04x %04x %04x\n",
-				mpx_audio_modes[t->mpxmode].modus,
-				source,
-				mpx_audio_modes[t->mpxmode].acb,
-				mpx_audio_modes[t->mpxmode].fm_prescale,
-				mpx_audio_modes[t->mpxmode].nicam_prescale,
-				mpx_audio_modes[t->mpxmode].scart_prescale,
-				mpx_audio_modes[t->mpxmode].system,
-				mpx_audio_modes[t->mpxmode].volume);
+		dev_dbg(&client->dev,
+			"MPX registers: %04x %04x %04x %04x %04x %04x %04x %04x\n",
+			mpx_audio_modes[t->mpxmode].modus,
+			source,
+			mpx_audio_modes[t->mpxmode].acb,
+			mpx_audio_modes[t->mpxmode].fm_prescale,
+			mpx_audio_modes[t->mpxmode].nicam_prescale,
+			mpx_audio_modes[t->mpxmode].scart_prescale,
+			mpx_audio_modes[t->mpxmode].system,
+			mpx_audio_modes[t->mpxmode].volume);
 		buf1[0] = 0x11;
 		buf1[1] = 0x00;
 		buf1[2] = 0x7e;
@@ -310,14 +310,14 @@ static int mpx_setup(struct i2c_client *client)
 		msgs[1].len = 2;
 		msgs[1].buf = buf2;
 		i2c_transfer(client->adapter, msgs, 2);
-		printk(KERN_DEBUG "wis-sony-tuner: MPX system: %02x%02x\n",
-				buf2[0], buf2[1]);
+		dev_dbg(&client->dev, "MPX system: %02x%02x\n",
+			buf2[0], buf2[1]);
 		buf1[0] = 0x11;
 		buf1[1] = 0x02;
 		buf1[2] = 0x00;
 		i2c_transfer(client->adapter, msgs, 2);
-		printk(KERN_DEBUG "wis-sony-tuner: MPX status: %02x%02x\n",
-				buf2[0], buf2[1]);
+		dev_dbg(&client->dev, "MPX status: %02x%02x\n",
+			buf2[0], buf2[1]);
 	}
 #endif
 	return 0;
@@ -375,8 +375,7 @@ static int set_if(struct i2c_client *client)
 		t->mpxmode = force_mpx_mode;
 	else
 		t->mpxmode = default_mpx_mode;
-	printk(KERN_DEBUG "wis-sony-tuner: setting MPX to mode %d\n",
-			t->mpxmode);
+	dev_dbg(&client->dev, "setting MPX to mode %d\n", t->mpxmode);
 	mpx_setup(client);
 
 	return 0;
@@ -401,8 +400,8 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 
 		if (t->type >= 0) {
 			if (t->type != *type)
-				printk(KERN_ERR "wis-sony-tuner: type already "
-					"set to %d, ignoring request for %d\n",
+				dev_err(&client->dev,
+					"type already set to %d, ignoring request for %d\n",
 					t->type, *type);
 			break;
 		}
@@ -414,28 +413,28 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			case 'B':
 			case 'g':
 			case 'G':
-				printk(KERN_INFO "wis-sony-tuner: forcing "
-						"tuner to PAL-B/G bands\n");
+				dev_info(&client->dev,
+					 "forcing tuner to PAL-B/G bands\n");
 				force_band = V4L2_STD_PAL_BG;
 				break;
 			case 'i':
 			case 'I':
-				printk(KERN_INFO "wis-sony-tuner: forcing "
-						"tuner to PAL-I band\n");
+				dev_info(&client->dev,
+					 "forcing tuner to PAL-I band\n");
 				force_band = V4L2_STD_PAL_I;
 				break;
 			case 'd':
 			case 'D':
 			case 'k':
 			case 'K':
-				printk(KERN_INFO "wis-sony-tuner: forcing "
-						"tuner to PAL-D/K bands\n");
+				dev_info(&client->dev,
+					 "forcing tuner to PAL-D/K bands\n");
 				force_band = V4L2_STD_PAL_I;
 				break;
 			case 'l':
 			case 'L':
-				printk(KERN_INFO "wis-sony-tuner: forcing "
-						"tuner to SECAM-L band\n");
+				dev_info(&client->dev,
+					 "forcing tuner to SECAM-L band\n");
 				force_band = V4L2_STD_SECAM_L;
 				break;
 			default:
@@ -455,14 +454,15 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			t->std = V4L2_STD_NTSC_M;
 			break;
 		default:
-			printk(KERN_ERR "wis-sony-tuner: tuner type %d is not "
-					"supported by this module\n", *type);
+			dev_err(&client->dev,
+				"tuner type %d is not supported by this module\n",
+				*type);
 			break;
 		}
 		if (type >= 0)
-			printk(KERN_INFO
-				"wis-sony-tuner: type set to %d (%s)\n",
-				t->type, sony_tuners[t->type - 200].name);
+			dev_info(&clinet->dev,
+				 "type set to %d (%s)\n",
+				 t->type, sony_tuners[t->type - 200].name);
 		break;
 	}
 #endif
@@ -544,9 +544,8 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			if (force_band && (*std & force_band) != *std &&
 					*std != V4L2_STD_PAL &&
 					*std != V4L2_STD_SECAM) {
-				printk(KERN_DEBUG "wis-sony-tuner: ignoring "
-						"requested TV standard in "
-						"favor of force_band value\n");
+				dev_dbg(&client->dev,
+					"ignoring requested TV standard in favor of force_band value\n");
 				t->std = force_band;
 			} else if (*std & V4L2_STD_PAL_BG) { /* default */
 				t->std = V4L2_STD_PAL_BG;
@@ -557,8 +556,8 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			} else if (*std & V4L2_STD_SECAM_L) {
 				t->std = V4L2_STD_SECAM_L;
 			} else {
-				printk(KERN_ERR "wis-sony-tuner: TV standard "
-						"not supported\n");
+				dev_err(&client->dev,
+					"TV standard not supported\n");
 				*std = 0; /* hack to indicate EINVAL */
 				break;
 			}
@@ -567,15 +566,15 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 			break;
 		case TUNER_SONY_BTF_PK467Z:
 			if (!(*std & V4L2_STD_NTSC_M_JP)) {
-				printk(KERN_ERR "wis-sony-tuner: TV standard "
-						"not supported\n");
+				dev_err(&client->dev,
+					"TV standard not supported\n");
 				*std = 0; /* hack to indicate EINVAL */
 			}
 			break;
 		case TUNER_SONY_BTF_PB463Z:
 			if (!(*std & V4L2_STD_NTSC_M)) {
-				printk(KERN_ERR "wis-sony-tuner: TV standard "
-						"not supported\n");
+				dev_err(&client->dev,
+					"TV standard not supported\n");
 				*std = 0; /* hack to indicate EINVAL */
 			}
 			break;
@@ -673,8 +672,7 @@ static int wis_sony_tuner_probe(struct i2c_client *client,
 	t->audmode = V4L2_TUNER_MODE_STEREO;
 	i2c_set_clientdata(client, t);
 
-	printk(KERN_DEBUG
-		"wis-sony-tuner: initializing tuner at address %d on %s\n",
+	dev_dbg(&client->dev, "initializing tuner at address %d on %s\n",
 		client->addr, adapter->name);
 
 	return 0;
-- 
1.7.9.5

