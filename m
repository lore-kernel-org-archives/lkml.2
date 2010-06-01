Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0FAL3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:29:18 -0400
Received: from mail.eleftheriou.eu ([86.35.2.10]:38197 "EHLO
	enigma.wired-net.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab0FAL3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:29:14 -0400
Date: Tue, 1 Jun 2010 14:28:39 +0300
From: Nanakos Chrysostomos <nanakos@wired-net.gr>
To: mchehab@infradead.org
Cc: hverkuil@xs4all.nl, julia@diku.dk, mkrufky@kernellabs.com,
       dheitmueller@kernellabs.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers: media: video: tuner-core.c: Fix checkpatch.pl
	issues.
Message-ID: <20100601112839.GA4410@limpeloula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix resolves checkpatch.pl issues for tuner-core.c file.

Signed-off-by: Nanakos Chrysostomos <nanakos@wired-net.gr>
---
 drivers/media/video/tuner-core.c |   91 +++++++++++++++++++++-----------------
 1 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index c4dab6c..432b710 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -33,7 +33,7 @@
 
 #define UNSET (-1U)
 
-#define PREFIX t->i2c->driver->driver.name
+#define PREFIX (t->i2c->driver->driver.name)
 
 /** This macro allows us to probe dynamically, avoiding static links */
 #ifdef CONFIG_MEDIA_ATTACH
@@ -149,7 +149,7 @@ static char ntsc[] = "-";
 module_param(addr, int, 0444);
 module_param(no_autodetect, int, 0444);
 module_param(show_i2c, int, 0444);
-module_param_named(debug,tuner_debug, int, 0644);
+module_param_named(debug, tuner_debug, int, 0644);
 module_param_string(pal, pal, sizeof(pal), 0644);
 module_param_string(secam, secam, sizeof(secam), 0644);
 module_param_string(ntsc, ntsc, sizeof(ntsc), 0644);
@@ -229,15 +229,15 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 	};
 
 	if (t->type == UNSET) {
-		tuner_warn ("tuner type not set\n");
+		tuner_warn("tuner type not set\n");
 		return;
 	}
 	if (NULL == analog_ops->set_params) {
-		tuner_warn ("Tuner has no way to set tv freq\n");
+		tuner_warn("Tuner has no way to set tv freq\n");
 		return;
 	}
 	if (freq < tv_range[0] * 16 || freq > tv_range[1] * 16) {
-		tuner_dbg ("TV freq (%d.%02d) out of range (%d-%d)\n",
+		tuner_dbg("TV freq (%d.%02d) out of range (%d-%d)\n",
 			   freq / 16, freq % 16 * 100 / 16, tv_range[0],
 			   tv_range[1]);
 		/* V4L2 spec: if the freq is not possible then the closest
@@ -264,15 +264,15 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 	};
 
 	if (t->type == UNSET) {
-		tuner_warn ("tuner type not set\n");
+		tuner_warn("tuner type not set\n");
 		return;
 	}
 	if (NULL == analog_ops->set_params) {
-		tuner_warn ("tuner has no way to set radio frequency\n");
+		tuner_warn("tuner has no way to set radio frequency\n");
 		return;
 	}
 	if (freq < radio_range[0] * 16000 || freq > radio_range[1] * 16000) {
-		tuner_dbg ("radio freq (%d.%02d) out of range (%d-%d)\n",
+		tuner_dbg("radio freq (%d.%02d) out of range (%d-%d)\n",
 			   freq / 16000, freq % 16000 * 100 / 16000,
 			   radio_range[0], radio_range[1]);
 		/* V4L2 spec: if the freq is not possible then the closest
@@ -306,7 +306,7 @@ static void set_freq(struct i2c_client *c, unsigned long freq)
 		t->tv_freq = freq;
 		break;
 	default:
-		tuner_dbg("freq set: unknown mode: 0x%04x!\n",t->mode);
+		tuner_dbg("freq set: unknown mode: 0x%04x!\n", t->mode);
 	}
 }
 
@@ -314,7 +314,8 @@ static struct xc5000_config xc5000_cfg;
 
 static void set_type(struct i2c_client *c, unsigned int type,
 		     unsigned int new_mode_mask, unsigned int new_config,
-		     int (*tuner_callback) (void *dev, int component, int cmd, int arg))
+		     int (*tuner_callback) (void *dev, int component,
+			     int cmd, int arg))
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 	struct dvb_tuner_ops *fe_tuner_ops = &t->fe.ops.tuner_ops;
@@ -323,7 +324,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	int tune_now = 1;
 
 	if (type == UNSET || type == TUNER_ABSENT) {
-		tuner_dbg ("tuner 0x%02x: Tuner type absent\n",c->addr);
+		tuner_dbg("tuner 0x%02x: Tuner type absent\n", c->addr);
 		return;
 	}
 
@@ -336,7 +337,8 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	}
 
 	if (t->mode == T_UNINITIALIZED) {
-		tuner_dbg ("tuner 0x%02x: called during i2c_client register by adapter's attach_inform\n", c->addr);
+		tuner_dbg("tuner 0x%02x: called during i2c_client register
+				by adapter's attach_inform\n", c->addr);
 
 		return;
 	}
@@ -497,23 +499,22 @@ static void set_addr(struct i2c_client *c, struct tuner_setup *tun_setup)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 
-	if ( (t->type == UNSET && ((tun_setup->addr == ADDR_UNSET) &&
+	if ((t->type == UNSET && ((tun_setup->addr == ADDR_UNSET) &&
 		(t->mode_mask & tun_setup->mode_mask))) ||
 		(tun_setup->addr == c->addr)) {
 			set_type(c, tun_setup->type, tun_setup->mode_mask,
 				 tun_setup->config, tun_setup->tuner_callback);
 	} else
 		tuner_dbg("set addr discarded for type %i, mask %x. "
-			  "Asked to change tuner at addr 0x%02x, with mask %x\n",
+			  "Asked to change tuner at addr 0x%02x,with mask %x\n",
 			  t->type, t->mode_mask,
 			  tun_setup->addr, tun_setup->mode_mask);
 }
 
 static inline int check_mode(struct tuner *t, char *cmd)
 {
-	if ((1 << t->mode & t->mode_mask) == 0) {
+	if ((1 << t->mode & t->mode_mask) == 0)
 		return -EINVAL;
-	}
 
 	switch (t->mode) {
 	case V4L2_TUNER_RADIO:
@@ -535,31 +536,31 @@ static int tuner_fixup_std(struct tuner *t)
 	if ((t->std & V4L2_STD_PAL) == V4L2_STD_PAL) {
 		switch (pal[0]) {
 		case '6':
-			tuner_dbg ("insmod fixup: PAL => PAL-60\n");
+			tuner_dbg("insmod fixup: PAL => PAL-60\n");
 			t->std = V4L2_STD_PAL_60;
 			break;
 		case 'b':
 		case 'B':
 		case 'g':
 		case 'G':
-			tuner_dbg ("insmod fixup: PAL => PAL-BG\n");
+			tuner_dbg("insmod fixup: PAL => PAL-BG\n");
 			t->std = V4L2_STD_PAL_BG;
 			break;
 		case 'i':
 		case 'I':
-			tuner_dbg ("insmod fixup: PAL => PAL-I\n");
+			tuner_dbg("insmod fixup: PAL => PAL-I\n");
 			t->std = V4L2_STD_PAL_I;
 			break;
 		case 'd':
 		case 'D':
 		case 'k':
 		case 'K':
-			tuner_dbg ("insmod fixup: PAL => PAL-DK\n");
+			tuner_dbg("insmod fixup: PAL => PAL-DK\n");
 			t->std = V4L2_STD_PAL_DK;
 			break;
 		case 'M':
 		case 'm':
-			tuner_dbg ("insmod fixup: PAL => PAL-M\n");
+			tuner_dbg("insmod fixup: PAL => PAL-M\n");
 			t->std = V4L2_STD_PAL_M;
 			break;
 		case 'N':
@@ -568,7 +569,7 @@ static int tuner_fixup_std(struct tuner *t)
 				tuner_dbg("insmod fixup: PAL => PAL-Nc\n");
 				t->std = V4L2_STD_PAL_Nc;
 			} else {
-				tuner_dbg ("insmod fixup: PAL => PAL-N\n");
+				tuner_dbg("insmod fixup: PAL => PAL-N\n");
 				t->std = V4L2_STD_PAL_N;
 			}
 			break;
@@ -576,7 +577,7 @@ static int tuner_fixup_std(struct tuner *t)
 			/* default parameter, do nothing */
 			break;
 		default:
-			tuner_warn ("pal= argument not recognised\n");
+			tuner_warn("pal= argument not recognised\n");
 			break;
 		}
 	}
@@ -589,22 +590,23 @@ static int tuner_fixup_std(struct tuner *t)
 		case 'h':
 		case 'H':
 			tuner_dbg("insmod fixup: SECAM => SECAM-BGH\n");
-			t->std = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H;
+			t->std = V4L2_STD_SECAM_B |
+				V4L2_STD_SECAM_G | V4L2_STD_SECAM_H;
 			break;
 		case 'd':
 		case 'D':
 		case 'k':
 		case 'K':
-			tuner_dbg ("insmod fixup: SECAM => SECAM-DK\n");
+			tuner_dbg("insmod fixup: SECAM => SECAM-DK\n");
 			t->std = V4L2_STD_SECAM_DK;
 			break;
 		case 'l':
 		case 'L':
-			if ((secam[1]=='C')||(secam[1]=='c')) {
-				tuner_dbg ("insmod fixup: SECAM => SECAM-L'\n");
+			if ((secam[1] == 'C') || (secam[1] == 'c')) {
+				tuner_dbg("insmod fixup: SECAM => SECAM-L'\n");
 				t->std = V4L2_STD_SECAM_LC;
 			} else {
-				tuner_dbg ("insmod fixup: SECAM => SECAM-L\n");
+				tuner_dbg("insmod fixup: SECAM => SECAM-L\n");
 				t->std = V4L2_STD_SECAM_L;
 			}
 			break;
@@ -612,7 +614,7 @@ static int tuner_fixup_std(struct tuner *t)
 			/* default parameter, do nothing */
 			break;
 		default:
-			tuner_warn ("secam= argument not recognised\n");
+			tuner_warn("secam= argument not recognised\n");
 			break;
 		}
 	}
@@ -654,10 +656,14 @@ static void tuner_status(struct dvb_frontend *fe)
 	const char *p;
 
 	switch (t->mode) {
-		case V4L2_TUNER_RADIO: 	    p = "radio"; break;
-		case V4L2_TUNER_ANALOG_TV:  p = "analog TV"; break;
-		case V4L2_TUNER_DIGITAL_TV: p = "digital TV"; break;
-		default: p = "undefined"; break;
+	case V4L2_TUNER_RADIO:
+		p = "radio"; break;
+	case V4L2_TUNER_ANALOG_TV:
+		p = "analog TV"; break;
+	case V4L2_TUNER_DIGITAL_TV:
+		p = "digital TV"; break;
+	default:
+		p = "undefined"; break;
 	}
 	if (t->mode == V4L2_TUNER_RADIO) {
 		freq = t->radio_freq / 16000;
@@ -669,8 +675,9 @@ static void tuner_status(struct dvb_frontend *fe)
 	tuner_info("Tuner mode:      %s\n", p);
 	tuner_info("Frequency:       %lu.%02lu MHz\n", freq, freq_fraction);
 	tuner_info("Standard:        0x%08lx\n", (unsigned long)t->std);
+
 	if (t->mode != V4L2_TUNER_RADIO)
-	       return;
+		return;
 	if (fe_tuner_ops->get_status) {
 		u32 tuner_status;
 
@@ -697,7 +704,8 @@ static void tuner_status(struct dvb_frontend *fe)
  * standby mode.
  */
 
-static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode, char *cmd)
+static inline int set_mode(struct i2c_client *client,
+		struct tuner *t, int mode, char *cmd)
 {
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
@@ -735,7 +743,8 @@ static int tuner_s_type_addr(struct v4l2_subdev *sd, struct tuner_setup *type)
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=0x%02x\n",
+	tuner_dbg("Calling set_type_addr for type=%d,
+			addr=0x%02x, mode=0x%02x, config=0x%02x\n",
 			type->type,
 			type->addr,
 			type->mode_mask,
@@ -775,7 +784,8 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 	return 0;
 }
 
-static int tuner_s_config(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *cfg)
+static int tuner_s_config(struct v4l2_subdev *sd,
+		const struct v4l2_priv_tun_config *cfg)
 {
 	struct tuner *t = to_tuner(sd);
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
@@ -1140,13 +1150,12 @@ register_client:
 		       client->adapter->name);
 
 	/* Sets a default mode */
-	if (t->mode_mask & T_ANALOG_TV) {
+	if (t->mode_mask & T_ANALOG_TV)
 		t->mode = V4L2_TUNER_ANALOG_TV;
-	} else  if (t->mode_mask & T_RADIO) {
+	else  if (t->mode_mask & T_RADIO)
 		t->mode = V4L2_TUNER_RADIO;
-	} else {
+	else
 		t->mode = V4L2_TUNER_DIGITAL_TV;
-	}
 	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
 	list_add_tail(&t->list, &tuner_list);
 	return 0;
-- 
1.5.6.5

