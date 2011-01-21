Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1AUKCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:02:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55846 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1AUKCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:02:13 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, manjugk@ti.com, gadiyar@ti.com,
        tony@atomide.com, govindraj@ti.com, gregkh@suse.de,
        andrei.emeltchenko@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCHv3] OMAP: Enable Magic SysRq on serial console ttyOx
Date: Fri, 21 Jan 2011 11:01:24 +0100
Message-Id: <1295604084-27761-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc2
X-Provags-ID: V02:K0:tAVTROuFpqi0MaJux9EouHv/eZTBp+8LMG/jlNgUptE
 zYoC/xC5Y9mYkhiHxYITuo8gJayjthDxz3hCNpaDv+YKMOzr2a
 3d7n6TmkhAj3THdo6L8AXL5v89QCt9xvrLRda6gF58jYiENpBA
 zkbMmrTGWwd+YO02wK02mEuJjpHgXo0KHKTpxTtH3z+Vmu9W74
 q3uvY/ZF+CJqnxQ0Lw1QA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magic SysRq key is not working for OMAP on new serial
console ttyOx because SUPPORT_SYSRQ is not defined
for omap-serial.

This patch defines SUPPORT_SYSRQ in omap-serial and
enables handling of Magic SysRq character.

Further there is an issue of losing first break character.
Removing the reset of the lsr_break_flag fixes this issue.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/serial/omap-serial.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 7f2f010..699b344 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -20,6 +20,10 @@
  * this driver as required for the omap-platform.
  */
 
+#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/console.h>
@@ -190,7 +194,6 @@ static inline void receive_chars(struct uart_omap_port *up, int *status)
 			if (up->port.line == up->port.cons->index) {
 				/* Recover the break flag from console xmit */
 				lsr |= up->lsr_break_flag;
-				up->lsr_break_flag = 0;
 			}
 #endif
 			if (lsr & UART_LSR_BI)
-- 
1.7.4.rc2

