Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0ESRXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:23:39 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50829 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab0ESRX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:23:29 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>
Subject: [PATCH 1/4] input: use ABS_CNT rather than (ABS_MAX + 1)
Date: Wed, 19 May 2010 19:22:34 +0200
Message-Id: <1274289757-2723-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/hid/hid-debug.c     |    2 +-
 drivers/input/joydev.c      |   10 +++++-----
 drivers/input/misc/uinput.c |    4 ++--
 include/linux/input.h       |   12 ++++++------
 include/linux/joystick.h    |    4 ++--
 include/linux/uinput.h      |   10 +++++-----
 6 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 56f314f..c940267 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -811,7 +811,7 @@ static const char *relatives[REL_MAX + 1] = {
 	[REL_WHEEL] = "Wheel",		[REL_MISC] = "Misc",
 };
 
-static const char *absolutes[ABS_MAX + 1] = {
+static const char *absolutes[ABS_CNT] = {
 	[ABS_X] = "X",			[ABS_Y] = "Y",
 	[ABS_Z] = "Z",			[ABS_RX] = "Rx",
 	[ABS_RY] = "Ry",		[ABS_RZ] = "Rz",
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index c52bec4..d1902ac 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -47,15 +47,15 @@ struct joydev {
 	struct mutex mutex;
 	struct device dev;
 
-	struct js_corr corr[ABS_MAX + 1];
+	struct js_corr corr[ABS_CNT];
 	struct JS_DATA_SAVE_TYPE glue;
 	int nabs;
 	int nkey;
 	__u16 keymap[KEY_MAX - BTN_MISC + 1];
 	__u16 keypam[KEY_MAX - BTN_MISC + 1];
-	__u8 absmap[ABS_MAX + 1];
-	__u8 abspam[ABS_MAX + 1];
-	__s16 abs[ABS_MAX + 1];
+	__u8 absmap[ABS_CNT];
+	__u8 abspam[ABS_CNT];
+	__s16 abs[ABS_CNT];
 };
 
 struct joydev_client {
@@ -826,7 +826,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 	joydev->handle.handler = handler;
 	joydev->handle.private = joydev;
 
-	for (i = 0; i < ABS_MAX + 1; i++)
+	for (i = 0; i < ABS_CNT; i++)
 		if (test_bit(i, dev->absbit)) {
 			joydev->absmap[i] = joydev->nabs;
 			joydev->abspam[joydev->nabs] = i;
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 1477466..f3f03b7 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -300,7 +300,7 @@ static int uinput_validate_absbits(struct input_dev *dev)
 	unsigned int cnt;
 	int retval = 0;
 
-	for (cnt = 0; cnt < ABS_MAX + 1; cnt++) {
+	for (cnt = 0; cnt < ABS_CNT; cnt++) {
 		if (!test_bit(cnt, dev->absbit))
 			continue;
 
@@ -387,7 +387,7 @@ static int uinput_setup_device(struct uinput_device *udev, const char __user *bu
 	dev->id.product	= user_dev->id.product;
 	dev->id.version	= user_dev->id.version;
 
-	size = sizeof(int) * (ABS_MAX + 1);
+	size = sizeof(int) * (ABS_CNT);
 	memcpy(dev->absmax, user_dev->absmax, size);
 	memcpy(dev->absmin, user_dev->absmin, size);
 	memcpy(dev->absfuzz, user_dev->absfuzz, size);
diff --git a/include/linux/input.h b/include/linux/input.h
index 7ed2251..0e41f77 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1154,7 +1154,7 @@ struct input_dev {
 
 	int sync;
 
-	int abs[ABS_MAX + 1];
+	int abs[ABS_CNT];
 	int rep[REP_MAX + 1];
 
 	unsigned long key[BITS_TO_LONGS(KEY_CNT)];
@@ -1162,11 +1162,11 @@ struct input_dev {
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
 	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
-	int absmax[ABS_MAX + 1];
-	int absmin[ABS_MAX + 1];
-	int absfuzz[ABS_MAX + 1];
-	int absflat[ABS_MAX + 1];
-	int absres[ABS_MAX + 1];
+	int absmax[ABS_CNT];
+	int absmin[ABS_CNT];
+	int absfuzz[ABS_CNT];
+	int absflat[ABS_CNT];
+	int absres[ABS_CNT];
 
 	int (*open)(struct input_dev *dev);
 	void (*close)(struct input_dev *dev);
diff --git a/include/linux/joystick.h b/include/linux/joystick.h
index 9e20c29..47199b1 100644
--- a/include/linux/joystick.h
+++ b/include/linux/joystick.h
@@ -64,8 +64,8 @@ struct js_event {
 #define JSIOCSCORR		_IOW('j', 0x21, struct js_corr)			/* set correction values */
 #define JSIOCGCORR		_IOR('j', 0x22, struct js_corr)			/* get correction values */
 
-#define JSIOCSAXMAP		_IOW('j', 0x31, __u8[ABS_MAX + 1])		/* set axis mapping */
-#define JSIOCGAXMAP		_IOR('j', 0x32, __u8[ABS_MAX + 1])		/* get axis mapping */
+#define JSIOCSAXMAP		_IOW('j', 0x31, __u8[ABS_CNT])			/* set axis mapping */
+#define JSIOCGAXMAP		_IOR('j', 0x32, __u8[ABS_CNT])			/* get axis mapping */
 #define JSIOCSBTNMAP		_IOW('j', 0x33, __u16[KEY_MAX - BTN_MISC + 1])	/* set button mapping */
 #define JSIOCGBTNMAP		_IOR('j', 0x34, __u16[KEY_MAX - BTN_MISC + 1])	/* get button mapping */
 
diff --git a/include/linux/uinput.h b/include/linux/uinput.h
index 15ddd44..60c81da 100644
--- a/include/linux/uinput.h
+++ b/include/linux/uinput.h
@@ -166,11 +166,11 @@ struct uinput_ff_erase {
 struct uinput_user_dev {
 	char name[UINPUT_MAX_NAME_SIZE];
 	struct input_id id;
-        int ff_effects_max;
-        int absmax[ABS_MAX + 1];
-        int absmin[ABS_MAX + 1];
-        int absfuzz[ABS_MAX + 1];
-        int absflat[ABS_MAX + 1];
+	int ff_effects_max;
+	int absmax[ABS_CNT];
+	int absmin[ABS_CNT];
+	int absfuzz[ABS_CNT];
+	int absflat[ABS_CNT];
 };
 #endif	/* __UINPUT_H_ */
 
-- 
1.7.1

