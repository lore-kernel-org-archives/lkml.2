Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2J0HlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 03:41:00 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:51532 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994Ab2J0Hk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 03:40:59 -0400
From: Roland Stigge <stigge@antcom.de>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] Input: select INPUT_MATRIXKMAP for lpc32xx-keys
Date: Sat, 27 Oct 2012 09:40:48 +0200
Message-Id: <1351323648-18645-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a "select" dependency of KEYBOARD_LPC32XX on INPUT_MATRIXKMAP,
as the other drivers are doing in this regard. This fixes the following compile
error if KEYBOARD_LPC32XX is enabled but INPUT_MATRIXKMAP is not:

drivers/input/keyboard/lpc32xx-keys.c:230: undefined reference to
`matrix_keypad_build_keymap'

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/input/keyboard/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.orig/drivers/input/keyboard/Kconfig
+++ linux-2.6/drivers/input/keyboard/Kconfig
@@ -335,6 +335,7 @@ config KEYBOARD_LOCOMO
 config KEYBOARD_LPC32XX
 	tristate "LPC32XX matrix key scanner support"
 	depends on ARCH_LPC32XX && OF
+	select INPUT_MATRIXKMAP
 	help
 	  Say Y here if you want to use NXP LPC32XX SoC key scanner interface,
 	  connected to a key matrix.
