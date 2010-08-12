Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983Ab0HLQW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:22:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32843 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967Ab0HLQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=o1XbnfNRPyIzjWJ04mvbJorTc0M656dKjPD+ARyfAil9YXZRkkXexRN31/qLGEWFdo
         ENnsNQ4KmcnUVTegJCCo901xEfE6hGH7v//SPx4zwLUrqBRWdpOB4/QVViSA4SajLLDx
         RaD5e6onRlA+glWshVFuTs+wySUyaBc9keYbk=
Date: Thu, 12 Aug 2010 09:22:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Input: fix faulty XXinput_* calls
Message-ID: <20100812162218.GA21286@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@caiaq.de>

They've been introduced by 987a6c02 ("Input: switch to input_abs_*()
access functions") and they appear to be some kind of debug left-over.

[Dmitry Torokhov: these are my fault - I added XX prefixes in places where
 I wanted to do additional review of the code but failed to actually do
 that in these particular instances.]

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/joystick/amijoy.c  |    2 +-
 drivers/input/keyboard/hil_kbd.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index e90694f..0bc8620 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -139,7 +139,7 @@ static int __init amijoy_init(void)
 		amijoy_dev[i]->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
 			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 		for (j = 0; j < 2; j++) {
-			XXinput_set_abs_params(amijoy_dev[i], ABS_X + j,
+			input_set_abs_params(amijoy_dev[i], ABS_X + j,
 					     -1, 1, 0, 0);
 		}
 
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index ddd5afd..dcc86b9 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -235,7 +235,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 			if (val < input_abs_min(dev, ABS_X + i))
 				input_abs_set_min(dev, ABS_X + i, val);
 			if (val > input_abs_max(dev, ABS_X + i))
-				XXinput_abs_set_max(dev, ABS_X + i, val);
+				input_abs_set_max(dev, ABS_X + i, val);
 #endif
 			if (i % 3)
 				val = input_abs_max(dev, ABS_X + i) - val;
@@ -391,7 +391,7 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
 			int diff = input_abs_max(input_dev, ABS_X + i) / 10;
 			input_abs_set_min(input_dev, ABS_X + i,
 				input_abs_min(input_dev, ABS_X + i) + diff)
-			XXinput_abs_set_max(input_dev, ABS_X + i,
+			input_abs_set_max(input_dev, ABS_X + i,
 				input_abs_max(input_dev, ABS_X + i) - diff)
 		}
 #endif
-- 
Dmitry
