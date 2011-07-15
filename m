Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab1GOMIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 08:08:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46309 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1GOMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 08:08:28 -0400
From: Colin Brophy <colin@brophys.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Colin Brophy <colin@brophys.com>
Subject: [PATCH] Staging: nvec: fixes coding style issues in nvec_kbd.c
Date: Fri, 15 Jul 2011 13:08:16 +0100
Message-Id: <1310731696-5374-1-git-send-email-colin@brophys.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches nvec_kbd.c to the file that fixes up errors found by
the checkpath.pl tool.

Signed-off-by: Colin Brophy <colin@brophys.com>
---
 drivers/staging/nvec/nvec_kbd.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/nvec/nvec_kbd.c b/drivers/staging/nvec/nvec_kbd.c
index 9a98507..04bd285 100644
--- a/drivers/staging/nvec/nvec_kbd.c
+++ b/drivers/staging/nvec/nvec_kbd.c
@@ -4,7 +4,7 @@
 #include "nvec-keytable.h"
 #include "nvec.h"
 
-#define ACK_KBD_EVENT {'\x05','\xed','\x01'}
+#define ACK_KBD_EVENT {'\x05', '\xed', '\x01'}
 
 static unsigned char keycodes[ARRAY_SIZE(code_tab_102us)
 			+ ARRAY_SIZE(extcode_tab_us102)];
@@ -27,10 +27,10 @@ static int nvec_keys_notifier(struct notifier_block *nb,
 		nvec_size _size = (msg[0] & (3 << 5)) >> 5;
 
 /* power on/off button */
-		if(_size == NVEC_VAR_SIZE)
+		if (_size == NVEC_VAR_SIZE)
 			return NOTIFY_STOP;
 
-		if(_size == NVEC_3BYTES)
+		if (_size == NVEC_3BYTES)
 			msg++;
 
 		code = msg[1] & 0x7f;
@@ -51,13 +51,13 @@ static int nvec_kbd_event(struct input_dev *dev, unsigned int type,
 	unsigned char buf[] = ACK_KBD_EVENT;
 	struct nvec_chip *nvec = keys_dev.nvec;
 
-	if(type==EV_REP)
+	if (type == EV_REP)
 		return 0;
 
-	if(type!=EV_LED)
+	if (type != EV_LED)
 		return -1;
 
-	if(code!=LED_CAPSL)
+	if (code != LED_CAPSL)
 		return -1;
 
 	buf[2] = !!value;
@@ -73,11 +73,11 @@ int __init nvec_kbd_init(struct nvec_chip *nvec)
 
 	j = 0;
 
-	for(i = 0; i < ARRAY_SIZE(code_tab_102us); ++i)
+	for (i = 0; i < ARRAY_SIZE(code_tab_102us); ++i)
 		keycodes[j++] = code_tab_102us[i];
 
-	for(i = 0; i < ARRAY_SIZE(extcode_tab_us102); ++i)
-		keycodes[j++]=extcode_tab_us102[i];
+	for (i = 0; i < ARRAY_SIZE(extcode_tab_us102); ++i)
+		keycodes[j++] = extcode_tab_us102[i];
 
 	idev = input_allocate_device();
 	idev->name = "Tegra nvec keyboard";
@@ -89,12 +89,12 @@ int __init nvec_kbd_init(struct nvec_chip *nvec)
 	idev->keycodesize = sizeof(unsigned char);
 	idev->keycodemax = ARRAY_SIZE(keycodes);
 
-	for( i = 0; i < ARRAY_SIZE(keycodes); ++i)
+	for (i = 0; i < ARRAY_SIZE(keycodes); ++i)
 		set_bit(keycodes[i], idev->keybit);
 
 	clear_bit(0, idev->keybit);
 	err = input_register_device(idev);
-	if(err)
+	if (err)
 		goto fail;
 
 	keys_dev.input = idev;
-- 
1.7.6

