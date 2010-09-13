Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0IMDw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 23:52:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47349 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab0IMDv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 23:51:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SCskAsvDMcXinMF/wZXbw/s06DYvxwO11LxgYS1OutQToFdtVtaBfX2ALUiE+hcplg
         UYRe7CLcaAu/XIhSune3czv8PRwIz9dGZPLEzJXPd/TItlAO4YscGsNjkJ4zDi3isQ3E
         nerReK+53caZb4Y28qKi5RCzKjWSb4g/LcZDM=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: eric.y.miao@gmail.com, marek.vasut@gmail.com, haojian.zhuang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        markb@marvell.com
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH v2 2/3] ARM: pxa168/teton bga: added keypad support
Date: Sun, 12 Sep 2010 23:51:35 -0400
Message-Id: <1284349896-14545-3-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com>
References: <1284349896-14545-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for Matrix keypad ESC, ENTER, LEFT, and RIGHT

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/teton_bga.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
index 49b746b..2966117 100644
--- a/arch/arm/mach-mmp/teton_bga.c
+++ b/arch/arm/mach-mmp/teton_bga.c
@@ -16,6 +16,8 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/input.h>
+#include <plat/pxa27x_keypad.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -30,6 +32,27 @@ static unsigned long teton_bga_pin_config[] __initdata = {
 	/* UART1 */
 	GPIO107_UART1_TXD,
 	GPIO108_UART1_RXD,
+
+	/* Keypad */
+	GPIO109_KP_MKIN1,
+	GPIO110_KP_MKIN0,
+	GPIO111_KP_MKOUT7,
+	GPIO112_KP_MKOUT6,
+};
+
+static unsigned int teton_bga_matrix_key_map[] = {
+	KEY(0, 6, KEY_ESC),
+	KEY(0, 7, KEY_ENTER),
+	KEY(1, 6, KEY_LEFT),
+	KEY(1, 7, KEY_RIGHT),
+};
+
+static struct pxa27x_keypad_platform_data teton_bga_keypad_info __initdata = {
+	.matrix_key_rows        = 2,
+	.matrix_key_cols        = 8,
+	.matrix_key_map         = teton_bga_matrix_key_map,
+	.matrix_key_map_size    = ARRAY_SIZE(teton_bga_matrix_key_map),
+	.debounce_interval      = 30,
 };
 
 static void __init teton_bga_init(void)
@@ -38,6 +61,7 @@ static void __init teton_bga_init(void)
 
 	/* on-chip devices */
 	pxa168_add_uart(1);
+	pxa168_add_keypad(&teton_bga_keypad_info);
 }
 
 MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
-- 
1.7.0.4

