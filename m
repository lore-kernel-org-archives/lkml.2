Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0ICVtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:49:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52205 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab0ICVtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KSNe4PkpgvMf7dxLeKVZX6iXtLX1jeX6N/bsrNpzSuxBT7s9rCsjDqH4GoZOjMkV/w
         hXqf7Z8xdCa9HgjPTpY5sGG7uIoZgLVt7HW6Sg1UHK88/EIey7lcjeGQCAuPq8ifzMPI
         15PLluI7v1m9J66X8KY/Kp/YQ0fS1UBkqCWm4=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 6/6] ARM: pxa168: aspenite: add board support for keypad
Date: Thu, 26 Aug 2010 11:27:37 -0400
Message-Id: <1282836457-5651-7-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
References: <1282836457-5651-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/aspenite.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 9e1bd6b..f04bae6 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -24,6 +24,8 @@
 #include <mach/pxa168.h>
 #include <mach/gpio.h>
 #include <video/pxa168fb.h>
+#include <linux/input.h>
+#include <plat/pxa27x_keypad.h>
 
 #include "common.h"
 
@@ -97,6 +99,13 @@ static unsigned long common_pin_config[] __initdata = {
 	GPIO81_LCD_DD21,
 	GPIO82_LCD_DD22,
 	GPIO83_LCD_DD23,
+
+	/* Keypad */
+	GPIO109_KP_MKIN1,
+	GPIO110_KP_MKIN0,
+	GPIO111_KP_MKOUT7,
+	GPIO112_KP_MKOUT6,
+	GPIO121_KP_MKIN4,
 };
 
 static struct smc91x_platdata smc91x_info = {
@@ -193,6 +202,23 @@ struct pxa168fb_mach_info aspenite_lcd_info = {
 	.invert_pixclock	= 0,
 };
 
+static unsigned int aspenite_matrix_key_map[] = {
+	KEY(0, 6, KEY_UP),	/* SW 4 */
+	KEY(0, 7, KEY_DOWN),	/* SW 5 */
+	KEY(1, 6, KEY_LEFT),	/* SW 6 */
+	KEY(1, 7, KEY_RIGHT),	/* SW 7 */
+	KEY(4, 6, KEY_ENTER),	/* SW 8 */
+	KEY(4, 7, KEY_ESC),	/* SW 9 */
+};
+
+static struct pxa27x_keypad_platform_data aspenite_keypad_info __initdata = {
+	.matrix_key_rows	= 5,
+	.matrix_key_cols	= 8,
+	.matrix_key_map		= aspenite_matrix_key_map,
+	.matrix_key_map_size	= ARRAY_SIZE(aspenite_matrix_key_map),
+	.debounce_interval	= 30,
+};
+
 static void __init common_init(void)
 {
 	mfp_config(ARRAY_AND_SIZE(common_pin_config));
@@ -203,6 +229,7 @@ static void __init common_init(void)
 	pxa168_add_ssp(1);
 	pxa168_add_nand(&aspenite_nand_info);
 	pxa168_add_fb(&aspenite_lcd_info);
+	pxa168_add_keypad(&aspenite_keypad_info);
 
 	/* off-chip devices */
 	platform_device_register(&smc91x_device);
-- 
1.7.0.4

