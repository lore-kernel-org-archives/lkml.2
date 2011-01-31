Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1AaQbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:31:21 -0500
Received: from kroah.org ([198.145.64.141]:46382 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab1AaQbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:31:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Daniel Hellstrom <daniel@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] tty/serial: fix apbuart build
Date: Mon, 31 Jan 2011 08:31:10 -0800
Message-Id: <1296491470-23096-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110131162852.GA22875@kroah.com>
References: <20110131162852.GA22875@kroah.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/serial/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index b1682d7..2b83346 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1518,6 +1518,7 @@ config SERIAL_BCM63XX_CONSOLE
 config SERIAL_GRLIB_GAISLER_APBUART
 	tristate "GRLIB APBUART serial support"
 	depends on OF
+	select SERIAL_CORE
 	---help---
 	Add support for the GRLIB APBUART serial port.
 
-- 
1.7.1

