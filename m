Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab0JAOYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:24:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37046 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0JAOYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RO6aHTBdfumlLAWb/MyGel3zEpWgOy600bY29kaUk+XeQetxZjEv1MZoEhf/QHv4bm
         q7AZhaKnWZ+Xg8d5WF+Okinls6yLB8U3eIdItS3L/i3mqiM6PjH/CCVJWd08Mt/whCpl
         ErIJyFyV9y8AurdxCG0QzPU3ROi9Ic5CVSYP8=
Date: Fri, 1 Oct 2010 18:23:24 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/8] altera_uart: Make it possible to use Altera UART
 and 8250 ports together
Message-ID: <20101001142324.GA4517@oksana.dev.rtsoft.ru>
References: <20101001132207.GE25897@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101001132207.GE25897@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes tty name, major and minor numbers. The major number
204 is used across many platform-specific serial drivers, so we
use that.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
---

Now minor is set to 213.

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
1.7.0.5
