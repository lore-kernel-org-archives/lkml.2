Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab0KLJXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:23:45 -0500
Received: from smtp.nokia.com ([147.243.128.24]:53379 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab0KLJXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:23:32 -0500
From: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 4/4] OMAP: Serial: remove redefined MDR1 register definitions
Date: Fri, 12 Nov 2010 11:21:42 +0200
Message-Id: <1289553702-28041-5-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289553702-28041-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1289553702-28041-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

Use definitions defined in serial_reg

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
---
 arch/arm/plat-omap/include/plat/omap-serial.h |    3 ---
 drivers/serial/omap-serial.c                  |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
index c8dae02..6a17880 100644
--- a/arch/arm/plat-omap/include/plat/omap-serial.h
+++ b/arch/arm/plat-omap/include/plat/omap-serial.h
@@ -31,9 +31,6 @@
  */
 #define OMAP_SERIAL_NAME	"ttyO"
 
-#define OMAP_MDR1_DISABLE	0x07
-#define OMAP_MDR1_MODE13X	0x03
-#define OMAP_MDR1_MODE16X	0x00
 #define OMAP_MODE13X_SPEED	230400
 
 /*
diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 14365f7..03a96db 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -753,7 +753,7 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* Protocol, Baud Rate, and Interrupt Settings */
 
-	serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_DISABLE);
+	serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
 	serial_out(up, UART_LCR, OMAP_UART_LCR_CONF_MDB);
 
 	up->efr = serial_in(up, UART_EFR);
@@ -774,9 +774,9 @@ serial_omap_set_termios(struct uart_port *port, struct ktermios *termios,
 	serial_out(up, UART_LCR, cval);
 
 	if (baud > 230400 && baud != 3000000)
-		serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_MODE13X);
+		serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_13X_MODE);
 	else
-		serial_out(up, UART_OMAP_MDR1, OMAP_MDR1_MODE16X);
+		serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_16X_MODE);
 
 	/* Hardware Flow Control Configuration */
 
-- 
1.7.0.4

