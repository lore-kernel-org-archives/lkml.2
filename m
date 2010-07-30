Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0G3UlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 16:41:25 -0400
Received: from solo.fdn.fr ([80.67.169.19]:60981 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab0G3UlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 16:41:23 -0400
Date: Fri, 30 Jul 2010 22:41:18 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dtor@mail.ru>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Make keyboard.c match braille-only keyboards
Message-ID: <20100730204117.GI4824@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dtor@mail.ru>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/keyboard.c also handles braille keys, so it should also match
braille-only keyboards.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 54109dc..25be210 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1315,10 +1315,14 @@ static bool kbd_match(struct input_handler *handler, struct input_dev *dev)
 	if (test_bit(EV_SND, dev->evbit))
 		return true;
 
-	if (test_bit(EV_KEY, dev->evbit))
+	if (test_bit(EV_KEY, dev->evbit)) {
 		for (i = KEY_RESERVED; i < BTN_MISC; i++)
 			if (test_bit(i, dev->keybit))
 				return true;
+		for (i = KEY_BRL_DOT1; i <= KEY_BRL_DOT10; i++)
+			if (test_bit(i, dev->keybit))
+				return true;
+	}
 
 	return false;
 }
