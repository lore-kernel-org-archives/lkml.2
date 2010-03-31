Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab0CaS4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:56:16 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:54778 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab0CaS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:56:12 -0400
X-MXL-Hash: 4bb39acc7107b4bc-0bb944ffe81537b195b0ffbf6ebbf9baee996e80
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: linux kernel <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Date: Wed, 31 Mar 2010 13:55:58 -0500
Subject: [PATCH] matrix_keypad: allow platform to disable key autorepeat
Thread-Topic: [PATCH] matrix_keypad: allow platform to disable key autorepeat
Thread-Index: AcrRA80MKZ2Bf98rTsCkKx0OtfnPkw==
Message-ID: <0D753D10438DA54287A00B02708426976369248B0D@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010032501)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=1SbFcCV1-1MA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=i00gxMtYAAAA:8 a=pGL]
X-AnalysisOut: [kceISAAAA:8 a=i3SbALq9Ss3tzhcXjfgA:9 a=ufPZm_B0F1c9jpA9lOu]
X-AnalysisOut: [Z-83syC8A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=MSl-tDqO]
X-AnalysisOut: [z04A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2VIuXmE015829

In an embedded system the matrix_keypad driver might be used to 
interface with an external control panel and not an actual keyboard.
On the control panel some of the keys could be used to turn on/off
various functions.  If key autorepeat is enabled this causes the
function to quickly toggle between the on and off states and makes
operation difficult.

Add an option in the platform-specific data to disable the key
autorepeat.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

---

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index d3c8b61..7d99b44 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -373,7 +373,9 @@ static int __devinit matrix_keypad_probe(struct platform_device *pdev)
 	input_dev->name		= pdev->name;
 	input_dev->id.bustype	= BUS_HOST;
 	input_dev->dev.parent	= &pdev->dev;
-	input_dev->evbit[0]	= BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	input_dev->evbit[0]	= BIT_MASK(EV_KEY);
+	if (!pdata->no_autorep)
+		input_dev->evbit[0] |= BIT_MASK(EV_REP);
 	input_dev->open		= matrix_keypad_start;
 	input_dev->close	= matrix_keypad_stop;
 
diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
index 3bd018b..1d9ca94 100644
--- a/include/linux/input/matrix_keypad.h
+++ b/include/linux/input/matrix_keypad.h
@@ -44,6 +44,7 @@ struct matrix_keymap_data {
  * @active_low: gpio polarity
  * @wakeup: controls whether the device should be set up as wakeup
  *	source
+ * @no_autorep: disable key autorepeat
  *
  * This structure represents platform-specific data that use used by
  * matrix_keypad driver to perform proper initialization.
@@ -64,6 +65,7 @@ struct matrix_keypad_platform_data {
 
 	bool		active_low;
 	bool		wakeup;
+	bool		no_autorep;
 };
 
 /**
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
