Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2DWM3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:29:06 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:53281 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab2DWM3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:29:03 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] mfd/stmpe: allow for const keyboard data
Date: Mon, 23 Apr 2012 14:28:44 +0200
Message-ID: <1335184124-9105-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Since it's not like we will re-arrange the keys at run-time, it
seems proper to allow the keymap data to be const. This solves
a compilation warning in ux500.

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/mfd/stmpe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 8516fd1..f8d5b4d 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -117,7 +117,7 @@ struct matrix_keymap_data;
  * @no_autorepeat: disable key autorepeat
  */
 struct stmpe_keypad_platform_data {
-	struct matrix_keymap_data *keymap_data;
+	const struct matrix_keymap_data *keymap_data;
 	unsigned int debounce_ms;
 	unsigned int scan_count;
 	bool no_autorepeat;
-- 
1.7.9.2

