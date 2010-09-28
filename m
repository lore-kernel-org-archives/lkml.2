Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0I1Nge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:36:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47083 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab0I1NgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:36:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=d9sYXfDMQ5P0jL16P/ziGznFwDLvrEFvRgPg70agTLuFTRE0fnGhdIX120n/cPOVPp
         3U6FzCBFqmY0k8NiPwo1NXH7v951MHiYMPObdZi7pbs45X7bEijQsAeBE0O/QN3+oOjD
         ydXlYBgZCzq69hT21Hvn1IAA1HU7I5bLu7Azs=
Date: Tue, 28 Sep 2010 17:35:45 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] altera_uart: Make it possible to use Altera UART and
 8250 ports together
Message-ID: <20100928133545.GE8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes tty name and major number conflicts. The major number
204 is used across many platform-specific serial drivers, so we
use that.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/serial/altera_uart.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index 0a1a066..6412357 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -28,6 +28,7 @@
 #include <linux/altera_uart.h>
 
 #define DRV_NAME "altera_uart"
+#define SERIAL_ALTERA_MAJOR 204
 
 /*
  * Altera UART register definitions according to the Nios UART datasheet:
@@ -471,7 +472,7 @@ static int __init altera_uart_console_setup(struct console *co, char *options)
 static struct uart_driver altera_uart_driver;
 
 static struct console altera_uart_console = {
-	.name	= "ttyS",
+	.name	= "ttyAL",
 	.write	= altera_uart_console_write,
 	.device	= uart_console_device,
 	.setup	= altera_uart_console_setup,
@@ -502,8 +503,8 @@ console_initcall(altera_uart_console_init);
 static struct uart_driver altera_uart_driver = {
 	.owner		= THIS_MODULE,
 	.driver_name	= DRV_NAME,
-	.dev_name	= "ttyS",
-	.major		= TTY_MAJOR,
+	.dev_name	= "ttyAL",
+	.major		= SERIAL_ALTERA_MAJOR,
 	.minor		= 64,
 	.nr		= CONFIG_SERIAL_ALTERA_UART_MAXPORTS,
 	.cons		= ALTERA_UART_CONSOLE,
@@ -600,3 +601,4 @@ MODULE_DESCRIPTION("Altera UART driver");
 MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);
+MODULE_ALIAS_CHARDEV_MAJOR(SERIAL_ALTERA_MAJOR);
-- 
1.7.0.5
