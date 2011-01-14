Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab1ANSHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:07:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37257 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab1ANSGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:06:53 -0500
Date: Fri, 14 Jan 2011 10:05:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] tty/serial: fix apbuart build
Message-Id: <20110114100520.0a30e076.randy.dunlap@oracle.com>
In-Reply-To: <20110114152637.e03eac52.sfr@canb.auug.org.au>
References: <20110114152637.e03eac52.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors by selecting SERIAL_CORE:

ERROR: "uart_register_driver" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_write_wakeup" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_update_timeout" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_get_divisor" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_get_baud_rate" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_add_one_port" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_unregister_driver" [drivers/tty/serial/apbuart.ko] undefined!
ERROR: "uart_remove_one_port" [drivers/tty/serial/apbuart.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Daniel Hellstrom <daniel@gaisler.com>
---
 drivers/tty/serial/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110114.orig/drivers/tty/serial/Kconfig
+++ linux-next-20110114/drivers/tty/serial/Kconfig
@@ -1518,6 +1518,7 @@ config SERIAL_BCM63XX_CONSOLE
 config SERIAL_GRLIB_GAISLER_APBUART
 	tristate "GRLIB APBUART serial support"
 	depends on OF
+	select SERIAL_CORE
 	---help---
 	Add support for the GRLIB APBUART serial port.
 
