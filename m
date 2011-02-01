Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1BAHbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:31:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1BAHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:31:22 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>,
        Kevin Hilman <khilman@ti.com> (commit_signer:1/2=50%),
        "Govindraj.R" <govindraj.raja@ti.com> (commit_signer:1/2=50%),
        Greg Kroah-Hartman <gregkh@suse.de> (commit_signer:1/2=50%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv4] OMAP: Enable Magic SysRq on serial console ttyOx
Date: Tue,  1 Feb 2011 08:30:41 +0100
Message-Id: <1296545441-17070-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc3
X-Provags-ID: V02:K0:VLHioMEPPJdYSIBRsSdUAPnKl3KpasfNhggF6QqXa50
 qVBH+W11Bz+J0gZv5+QI2+Blfs1YXLGnbA3ztkS8mW2TiktzJJ
 usVq321o8+v/Au+wcQorRjK77sinRTqNLXGNZv0a4mzufFMPWS
 Qj6nMB1UYB2LS8gjOg2vddGHomZsO7n7ylcpgcUhN5ViHgl9uB
 9pP35AKBagFw/Yo3wbRYQ==
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
Acked-by: Govindraj.R <govindraj.raja@ti.com>
Tested-by: Manjunath G Kondaiah <manjugk@ti.com>
Acked-by: Kevin Hilman <khilman@ti.com>
---
v3->v4
	Rebased to 2.6.38-rc2 after move of drivers/serial to drivers/tty/serial
	Added Acked-by and Tested-by

 drivers/tty/serial/omap-serial.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 7f2f010..699b344 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
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
1.7.4.rc3

