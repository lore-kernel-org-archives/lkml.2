Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758707Ab0JVSXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:23:31 -0400
Received: from kroah.org ([198.145.64.141]:37694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0JVSX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:23:28 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/49] altera_uart: Make it possible to use Altera UART and 8250 ports together
Date: Fri, 22 Oct 2010 11:21:17 -0700
Message-Id: <1287771688-14805-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

This fixes tty name, major and minor numbers. The major number
204 is used across many platform-specific serial drivers, so we
use that.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/altera_uart.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index f1985aa..fbc8f8e 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -28,6 +28,8 @@
 #include <linux/altera_uart.h>
 
 #define DRV_NAME "altera_uart"
+#define SERIAL_ALTERA_MAJOR 204
+#define SERIAL_ALTERA_MINOR 213
 
 /*
  * Altera UART register definitions according to the Nios UART datasheet:
@@ -471,7 +473,7 @@ static int __init altera_uart_console_setup(struct console *co, char *options)
 static struct uart_driver altera_uart_driver;
 
 static struct console altera_uart_console = {
-	.name	= "ttyS",
+	.name	= "ttyAL",
 	.write	= altera_uart_console_write,
 	.device	= uart_console_device,
 	.setup	= altera_uart_console_setup,
@@ -502,9 +504,9 @@ console_initcall(altera_uart_console_init);
 static struct uart_driver altera_uart_driver = {
 	.owner		= THIS_MODULE,
 	.driver_name	= DRV_NAME,
-	.dev_name	= "ttyS",
-	.major		= TTY_MAJOR,
-	.minor		= 64,
+	.dev_name	= "ttyAL",
+	.major		= SERIAL_ALTERA_MAJOR,
+	.minor		= SERIAL_ALTERA_MINOR,
 	.nr		= CONFIG_SERIAL_ALTERA_UART_MAXPORTS,
 	.cons		= ALTERA_UART_CONSOLE,
 };
@@ -603,3 +605,4 @@ MODULE_DESCRIPTION("Altera UART driver");
 MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);
+MODULE_ALIAS_CHARDEV_MAJOR(SERIAL_ALTERA_MAJOR);
-- 
1.7.2

