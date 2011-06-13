Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1FMSIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:08:10 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:40274 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1FMSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:08:06 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/atari: Prefix GPIO_{IN,OUT} with CODEC_
Date: Mon, 13 Jun 2011 20:07:58 +0200
Message-Id: <1307988478-21476-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These defines are way to generic, and cause conflicts:

drivers/net/wireless/rtlwifi/rtl8192c/../rtl8192ce/reg.h:369:1: warning: "GPIO_IN" redefined
drivers/net/wireless/rtlwifi/rtl8192c/../rtl8192ce/reg.h:370:1: warning: "GPIO_OUT" redefined
drivers/net/wireless/rtlwifi/rtl8192se/reg.h:252:1: warning: "GPIO_IN" redefined
drivers/net/wireless/rtlwifi/rtl8192se/reg.h:253:1: warning: "GPIO_OUT" redefined

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/atarihw.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/atarihw.h b/arch/m68k/include/asm/atarihw.h
index 9c5ab1c..83552ad 100644
--- a/arch/m68k/include/asm/atarihw.h
+++ b/arch/m68k/include/asm/atarihw.h
@@ -402,8 +402,8 @@ struct CODEC
 #define CODEC_OVERFLOW_LEFT     2
   u_char unused2, unused3, unused4, unused5;
   u_char gpio_directions;
-#define GPIO_IN                 0
-#define GPIO_OUT                1
+#define CODEC_GPIO_IN           0
+#define CODEC_GPIO_OUT          1
   u_char unused6;
   u_char gpio_data;
 };
-- 
1.7.0.4

