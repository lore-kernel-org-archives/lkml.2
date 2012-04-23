Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2DWJPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:15:04 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:34530 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645Ab2DWJPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:15:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Rikard Olsson <rikard.p.olsson@stericsson.com>
Subject: [PATCH 6/9] plat-nomadik: new sleep mode pincfg macros
Date: Mon, 23 Apr 2012 11:14:50 +0200
Message-ID: <1335172490-27683-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This adds a few sleep mode pin config macros for sleep mode
for the Nomadik GPIO/pin controller.

Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Signed-off-by: Rikard Olsson <rikard.p.olsson@stericsson.com>
Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/include/plat/pincfg.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/plat-nomadik/include/plat/pincfg.h b/arch/arm/plat-nomadik/include/plat/pincfg.h
index da6b1e3..c015133 100644
--- a/arch/arm/plat-nomadik/include/plat/pincfg.h
+++ b/arch/arm/plat-nomadik/include/plat/pincfg.h
@@ -24,6 +24,7 @@
  *	bit 16..18 - SLPM pull up/down state
  *	bit 19..20 - SLPM direction
  *	bit 21..22 - SLPM Value (if output)
+ *	bit 23..25 - PDIS value (if input)
  *
  * to facilitate the definition, the following macros are provided
  *
@@ -67,6 +68,10 @@ typedef unsigned long pin_cfg_t;
 /* These two replace the above in DB8500v2+ */
 #define PIN_SLPM_WAKEUP_ENABLE	(NMK_GPIO_SLPM_WAKEUP_ENABLE << PIN_SLPM_SHIFT)
 #define PIN_SLPM_WAKEUP_DISABLE	(NMK_GPIO_SLPM_WAKEUP_DISABLE << PIN_SLPM_SHIFT)
+#define PIN_SLPM_USE_MUX_SETTINGS_IN_SLEEP PIN_SLPM_WAKEUP_DISABLE
+
+#define PIN_SLPM_GPIO  PIN_SLPM_WAKEUP_ENABLE /* In SLPM, pin is a gpio */
+#define PIN_SLPM_ALTFUNC PIN_SLPM_WAKEUP_DISABLE /* In SLPM, pin is altfunc */
 
 #define PIN_DIR_SHIFT		14
 #define PIN_DIR_MASK		(0x1 << PIN_DIR_SHIFT)
@@ -105,6 +110,14 @@ typedef unsigned long pin_cfg_t;
 #define PIN_SLPM_VAL_LOW	((1 + 0) << PIN_SLPM_VAL_SHIFT)
 #define PIN_SLPM_VAL_HIGH	((1 + 1) << PIN_SLPM_VAL_SHIFT)
 
+#define PIN_SLPM_PDIS_SHIFT		23
+#define PIN_SLPM_PDIS_MASK		(0x3 << PIN_SLPM_PDIS_SHIFT)
+#define PIN_SLPM_PDIS(x)	\
+	(((x) & PIN_SLPM_PDIS_MASK) >> PIN_SLPM_PDIS_SHIFT)
+#define PIN_SLPM_PDIS_NO_CHANGE		(0 << PIN_SLPM_PDIS_SHIFT)
+#define PIN_SLPM_PDIS_DISABLED		(1 << PIN_SLPM_PDIS_SHIFT)
+#define PIN_SLPM_PDIS_ENABLED		(2 << PIN_SLPM_PDIS_SHIFT)
+
 #define PIN_LOWEMI_SHIFT	25
 #define PIN_LOWEMI_MASK		(0x1 << PIN_LOWEMI_SHIFT)
 #define PIN_LOWEMI(x)		(((x) & PIN_LOWEMI_MASK) >> PIN_LOWEMI_SHIFT)
-- 
1.7.9.2

