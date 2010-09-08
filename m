Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab0IHC5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:57:07 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39374 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab0IHC5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IXz5vm+foDx3Klczw4oqe/anolWaS0zWTGbPF2FdNjdkciBNnh5EQ5PyXRtnZ4RmgY
         jgWP5+pOoAF5mXW1ogJsujV0EGtvZHSkA+Ipo0DsZYLhqeCc2z88HfY/Q3eFSV+bRY9k
         M/VeqKUkgA+e9Bro7yiTKXHeZTow/ia+UQbEQ=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH 2/3] ARM: pxa168/teton bga: added keypad support
Date: Tue,  7 Sep 2010 22:56:46 -0400
Message-Id: <1283914607-10570-3-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283914607-10570-1-git-send-email-mark.brown314@gmail.com>
References: <1283914607-10570-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 arch/arm/mach-mmp/teton_bga.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
index 014cc37..bbeda5c 100644
--- a/arch/arm/mach-mmp/teton_bga.c
+++ b/arch/arm/mach-mmp/teton_bga.c
@@ -20,6 +20,8 @@
 #include <mach/mfp-pxa168.h>
 #include <mach/pxa168.h>
 #include <mach/gpio.h>
+#include <linux/input.h>
+#include <plat/pxa27x_keypad.h>
 
 #include "common.h"
 
@@ -27,6 +29,27 @@ static unsigned long teton_bga_pin_config[] __initdata = {
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
@@ -35,6 +58,7 @@ static void __init teton_bga_init(void)
 
 	/* on-chip devices */
 	pxa168_add_uart(1);
+	pxa168_add_keypad(&teton_bga_keypad_info);
 }
 
 MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
-- 
1.7.0.4

