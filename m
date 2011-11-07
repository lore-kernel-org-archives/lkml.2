Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab1KGDZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 22:25:08 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:28197 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1KGDZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 22:25:06 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Nov 2011 22:25:05 EST
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: JJ Ding <jj_ding@emc.com.tw>, JJ Ding <dgdunix@gmail.com>
Subject: [PATCH] Input: convert obsolete strict_strtox to kstrtox
Date: Mon,  7 Nov 2011 11:12:50 +0800
Message-Id: <1320635570-18860-1-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.8.rc0.32.g87bf9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JJ Ding <dgdunix@gmail.com>

With commit 67d0a0754455f89ef3946946159d8ec9e45ce33a we mark strict_strtox
as obsolete. Convert all remaining such uses in drivers/input/.

Signed-off-by: JJ Ding <dgdunix@gmail.com>
---
 drivers/input/input-polldev.c       |    2 +-
 drivers/input/keyboard/atkbd.c      |   10 +++++-----
 drivers/input/keyboard/lm8323.c     |    4 ++--
 drivers/input/misc/adxl34x.c        |    8 ++++----
 drivers/input/misc/ati_remote2.c    |    6 +++---
 drivers/input/mouse/elantech.c      |    2 +-
 drivers/input/mouse/hgpk.c          |    4 ++--
 drivers/input/mouse/logips2pp.c     |    2 +-
 drivers/input/mouse/psmouse-base.c  |    6 +++---
 drivers/input/mouse/sentelic.c      |   10 +++++-----
 drivers/input/mouse/trackpoint.c    |    4 ++--
 drivers/input/tablet/aiptek.c       |   10 +++++-----
 drivers/input/touchscreen/ad7877.c  |    8 ++++----
 drivers/input/touchscreen/ad7879.c  |    2 +-
 drivers/input/touchscreen/ads7846.c |    2 +-
 15 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index b253973..03202b2 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -85,7 +85,7 @@ static ssize_t input_polldev_set_poll(struct device *dev,
 	struct input_dev *input = polldev->input;
 	unsigned long interval;
 
-	if (strict_strtoul(buf, 0, &interval))
+	if (kstrtoul(buf, 0, &interval))
 		return -EINVAL;
 
 	if (interval < polldev->poll_interval_min)
diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 19cfc0c..b2cc7dd 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1313,7 +1313,7 @@ static ssize_t atkbd_set_extra(struct atkbd *atkbd, const char *buf, size_t coun
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtoul(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->extra != value) {
@@ -1393,7 +1393,7 @@ static ssize_t atkbd_set_scroll(struct atkbd *atkbd, const char *buf, size_t cou
 	int err;
 	bool old_scroll;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtoul(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->scroll != value) {
@@ -1441,7 +1441,7 @@ static ssize_t atkbd_set_set(struct atkbd *atkbd, const char *buf, size_t count)
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || (value != 2 && value != 3))
+	if (kstrtoul(buf, 10, &value) || (value != 2 && value != 3))
 		return -EINVAL;
 
 	if (atkbd->set != value) {
@@ -1491,7 +1491,7 @@ static ssize_t atkbd_set_softrepeat(struct atkbd *atkbd, const char *buf, size_t
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtoul(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->softrepeat != value) {
@@ -1538,7 +1538,7 @@ static ssize_t atkbd_set_softraw(struct atkbd *atkbd, const char *buf, size_t co
 	int err;
 	bool old_softraw;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtoul(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->softraw != value) {
diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index 82d1dc8..e830aa3 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -548,7 +548,7 @@ static ssize_t lm8323_pwm_store_time(struct device *dev,
 	int ret;
 	unsigned long time;
 
-	ret = strict_strtoul(buf, 10, &time);
+	ret = kstrtoul(buf, 10, &time);
 	/* Numbers only, please. */
 	if (ret)
 		return -EINVAL;
@@ -615,7 +615,7 @@ static ssize_t lm8323_set_disable(struct device *dev,
 	int ret;
 	unsigned long i;
 
-	ret = strict_strtoul(buf, 10, &i);
+	ret = kstrtoul(buf, 10, &i);
 
 	mutex_lock(&lm->lock);
 	lm->kp_enabled = !i;
diff --git a/drivers/input/misc/adxl34x.c b/drivers/input/misc/adxl34x.c
index 144ddbd..172a9a1 100644
--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -454,7 +454,7 @@ static ssize_t adxl34x_disable_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -543,7 +543,7 @@ static ssize_t adxl34x_rate_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -578,7 +578,7 @@ static ssize_t adxl34x_autosleep_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -628,7 +628,7 @@ static ssize_t adxl34x_write_store(struct device *dev,
 	/*
 	 * This allows basic ADXL register write access for debug purposes.
 	 */
-	error = strict_strtoul(buf, 16, &val);
+	error = kstrtoul(buf, 16, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 1de58e8..941a360 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -47,7 +47,7 @@ static int ati_remote2_set_mask(const char *val,
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtoul(val, 0, &mask);
+	ret = kstrtoul(val, 0, &mask);
 	if (ret)
 		return ret;
 
@@ -722,7 +722,7 @@ static ssize_t ati_remote2_store_channel_mask(struct device *dev,
 	unsigned long mask;
 	int r;
 
-	if (strict_strtoul(buf, 0, &mask))
+	if (kstrtoul(buf, 0, &mask))
 		return -EINVAL;
 
 	if (mask & ~ATI_REMOTE2_MAX_CHANNEL_MASK)
@@ -770,7 +770,7 @@ static ssize_t ati_remote2_store_mode_mask(struct device *dev,
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
 	unsigned long mask;
 
-	if (strict_strtoul(buf, 0, &mask))
+	if (kstrtoul(buf, 0, &mask))
 		return -EINVAL;
 
 	if (mask & ~ATI_REMOTE2_MAX_MODE_MASK)
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 09b93b1..99931aa 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1034,7 +1034,7 @@ static ssize_t elantech_set_int_attr(struct psmouse *psmouse,
 	unsigned long value;
 	int err;
 
-	err = strict_strtoul(buf, 16, &value);
+	err = kstrtoul(buf, 16, &value);
 	if (err)
 		return err;
 
diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index 0470dd4..b9f2371 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -792,7 +792,7 @@ static ssize_t hgpk_set_powered(struct psmouse *psmouse, void *data,
 	unsigned long value;
 	int err;
 
-	err = strict_strtoul(buf, 10, &value);
+	err = kstrtoul(buf, 10, &value);
 	if (err || value > 1)
 		return -EINVAL;
 
@@ -884,7 +884,7 @@ static ssize_t hgpk_trigger_recal(struct psmouse *psmouse, void *data,
 	unsigned long value;
 	int err;
 
-	err = strict_strtoul(buf, 10, &value);
+	err = kstrtoul(buf, 10, &value);
 	if (err || value != 1)
 		return -EINVAL;
 
diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
index faac2c3..f90ae35 100644
--- a/drivers/input/mouse/logips2pp.c
+++ b/drivers/input/mouse/logips2pp.c
@@ -157,7 +157,7 @@ static ssize_t ps2pp_attr_set_smartscroll(struct psmouse *psmouse, void *data,
 {
 	unsigned long value;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtoul(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	ps2pp_set_smartscroll(psmouse, value);
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 9f352fb..2177c5a 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1560,7 +1560,7 @@ static ssize_t psmouse_set_int_attr(struct psmouse *psmouse, void *offset, const
 	unsigned int *field = (unsigned int *)((char *)psmouse + (size_t)offset);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 10, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	if ((unsigned int)value != value)
@@ -1673,7 +1673,7 @@ static ssize_t psmouse_attr_set_rate(struct psmouse *psmouse, void *data, const
 {
 	unsigned long value;
 
-	if (strict_strtoul(buf, 10, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	psmouse->set_rate(psmouse, value);
@@ -1684,7 +1684,7 @@ static ssize_t psmouse_attr_set_resolution(struct psmouse *psmouse, void *data,
 {
 	unsigned long value;
 
-	if (strict_strtoul(buf, 10, &value))
+	if (kstrtoul(buf, 10, &value))
 		return -EINVAL;
 
 	psmouse->set_resolution(psmouse, value);
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index c5b12d2..d705d6b 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -416,7 +416,7 @@ static ssize_t fsp_attr_set_setreg(struct psmouse *psmouse, void *data,
 	if (rest == buf || *rest != ' ' || reg > 0xff)
 		return -EINVAL;
 
-	if (strict_strtoul(rest + 1, 16, &val) || val > 0xff)
+	if (kstrtoul(rest + 1, 16, &val) || val > 0xff)
 		return -EINVAL;
 
 	if (fsp_reg_write_enable(psmouse, true))
@@ -451,7 +451,7 @@ static ssize_t fsp_attr_set_getreg(struct psmouse *psmouse, void *data,
 	unsigned long reg;
 	int val;
 
-	if (strict_strtoul(buf, 16, &reg) || reg > 0xff)
+	if (kstrtoul(buf, 16, &reg) || reg > 0xff)
 		return -EINVAL;
 
 	if (fsp_reg_read(psmouse, reg, &val))
@@ -482,7 +482,7 @@ static ssize_t fsp_attr_set_pagereg(struct psmouse *psmouse, void *data,
 {
 	unsigned long val;
 
-	if (strict_strtoul(buf, 16, &val) || val > 0xff)
+	if (kstrtoul(buf, 16, &val) || val > 0xff)
 		return -EINVAL;
 
 	if (fsp_page_reg_write(psmouse, val))
@@ -507,7 +507,7 @@ static ssize_t fsp_attr_set_vscroll(struct psmouse *psmouse, void *data,
 {
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val) || val > 1)
+	if (kstrtoul(buf, 10, &val) || val > 1)
 		return -EINVAL;
 
 	fsp_onpad_vscr(psmouse, val);
@@ -531,7 +531,7 @@ static ssize_t fsp_attr_set_hscroll(struct psmouse *psmouse, void *data,
 {
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val) || val > 1)
+	if (kstrtoul(buf, 10, &val) || val > 1)
 		return -EINVAL;
 
 	fsp_onpad_hscr(psmouse, val);
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 54b2fa8..2595b8d 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -91,7 +91,7 @@ static ssize_t trackpoint_set_int_attr(struct psmouse *psmouse, void *data,
 	unsigned char *field = (unsigned char *)((char *)tp + attr->field_offset);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 10, &value) || value > 255)
+	if (kstrtoul(buf, 10, &value) || value > 255)
 		return -EINVAL;
 
 	*field = value;
@@ -117,7 +117,7 @@ static ssize_t trackpoint_set_bit_attr(struct psmouse *psmouse, void *data,
 	unsigned char *field = (unsigned char *)((char *)tp + attr->field_offset);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtoul(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (attr->inverted)
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 6d89fd1..b115a26 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1200,7 +1200,7 @@ store_tabletXtilt(struct device *dev, struct device_attribute *attr, const char
 	struct aiptek *aiptek = dev_get_drvdata(dev);
 	long x;
 
-	if (strict_strtol(buf, 10, &x)) {
+	if (kstrtol(buf, 10, &x)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
 		if (strncmp(buf, "disable", len))
@@ -1242,7 +1242,7 @@ store_tabletYtilt(struct device *dev, struct device_attribute *attr, const char
 	struct aiptek *aiptek = dev_get_drvdata(dev);
 	long y;
 
-	if (strict_strtol(buf, 10, &y)) {
+	if (kstrtol(buf, 10, &y)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
 		if (strncmp(buf, "disable", len))
@@ -1279,7 +1279,7 @@ store_tabletJitterDelay(struct device *dev, struct device_attribute *attr, const
 	struct aiptek *aiptek = dev_get_drvdata(dev);
 	long j;
 
-	if (strict_strtol(buf, 10, &j))
+	if (kstrtol(buf, 10, &j))
 		return -EINVAL;
 
 	aiptek->newSetting.jitterDelay = (int)j;
@@ -1308,7 +1308,7 @@ store_tabletProgrammableDelay(struct device *dev, struct device_attribute *attr,
 	struct aiptek *aiptek = dev_get_drvdata(dev);
 	long d;
 
-	if (strict_strtol(buf, 10, &d))
+	if (kstrtol(buf, 10, &d))
 		return -EINVAL;
 
 	aiptek->newSetting.programmableDelay = (int)d;
@@ -1559,7 +1559,7 @@ store_tabletWheel(struct device *dev, struct device_attribute *attr, const char
 	struct aiptek *aiptek = dev_get_drvdata(dev);
 	long w;
 
-	if (strict_strtol(buf, 10, &w)) return -EINVAL;
+	if (kstrtol(buf, 10, &w)) return -EINVAL;
 
 	aiptek->newSetting.wheel = (int)w;
 	return count;
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 714d4e0..76a26a8 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -490,7 +490,7 @@ static ssize_t ad7877_disable_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -520,7 +520,7 @@ static ssize_t ad7877_dac_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -550,7 +550,7 @@ static ssize_t ad7877_gpio3_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -581,7 +581,7 @@ static ssize_t ad7877_gpio4_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index 131f9d1..567c52e 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -342,7 +342,7 @@ static ssize_t ad7879_disable_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index d507b9b..5e09059 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -603,7 +603,7 @@ static ssize_t ads7846_disable_store(struct device *dev,
 	struct ads7846 *ts = dev_get_drvdata(dev);
 	unsigned long i;
 
-	if (strict_strtoul(buf, 10, &i))
+	if (kstrtoul(buf, 10, &i))
 		return -EINVAL;
 
 	if (i)
-- 
1.7.8.rc0.32.g87bf9

