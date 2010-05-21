Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098Ab0EUQwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:52:06 -0400
Received: from kroah.org ([198.145.64.141]:50293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934030Ab0EUQwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/25] serial: bfin_sport_uart: rename early platform driver class string
Date: Fri, 21 May 2010 09:51:34 -0700
Message-Id: <1274460714-11277-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Clarifies command line set up for devices between consoles and early
devices.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 49e7e4f..7925266 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -527,6 +527,8 @@ struct uart_ops sport_uart_ops = {
 static struct sport_uart_port *bfin_sport_uart_ports[BFIN_SPORT_UART_MAX_PORTS];
 
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
+#define CLASS_BFIN_SPORT_CONSOLE	"bfin-sport-console"
+
 static int __init
 sport_uart_console_setup(struct console *co, char *options)
 {
@@ -788,7 +790,7 @@ static struct platform_driver sport_uart_driver = {
 
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
 static __initdata struct early_platform_driver early_sport_uart_driver = {
-	.class_str = DRV_NAME,
+	.class_str = CLASS_BFIN_SPORT_CONSOLE,
 	.pdrv = &sport_uart_driver,
 	.requested_id = EARLY_PLATFORM_ID_UNSET,
 };
@@ -797,7 +799,8 @@ static int __init sport_uart_rs_console_init(void)
 {
 	early_platform_driver_register(&early_sport_uart_driver, DRV_NAME);
 
-	early_platform_driver_probe(DRV_NAME, BFIN_SPORT_UART_MAX_PORTS, 0);
+	early_platform_driver_probe(CLASS_BFIN_SPORT_CONSOLE,
+		BFIN_SPORT_UART_MAX_PORTS, 0);
 
 	register_console(&sport_uart_console);
 
-- 
1.7.0.3

