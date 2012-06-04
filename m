Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2FDLkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:40 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44997 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 23/24] TTY: add tty_port_register_device helper
Date: Mon,  4 Jun 2012 13:35:37 +0200
Message-Id: <1338809738-18967-24-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will automatically assign tty_port to tty_driver's port array for
later recall in tty_init_dev. This is intended to be called instead of
tty_register_device.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_port.c |    9 +++++++++
 include/linux/tty.h    |    3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 1ac8abf..4e9d2b2 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -33,6 +33,15 @@ void tty_port_init(struct tty_port *port)
 }
 EXPORT_SYMBOL(tty_port_init);
 
+struct device *tty_port_register_device(struct tty_port *port,
+		struct tty_driver *driver, unsigned index,
+		struct device *device)
+{
+	driver->ports[index] = port;
+	return tty_register_device(driver, index, device);
+}
+EXPORT_SYMBOL_GPL(tty_port_register_device);
+
 int tty_port_alloc_xmit_buf(struct tty_port *port)
 {
 	/* We may sleep in get_zeroed_page() */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 45ef71d..40b18d7 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -497,6 +497,9 @@ extern int tty_write_lock(struct tty_struct *tty, int ndelay);
 #define tty_is_writelocked(tty)  (mutex_is_locked(&tty->atomic_write_lock))
 
 extern void tty_port_init(struct tty_port *port);
+extern struct device *tty_port_register_device(struct tty_port *port,
+		struct tty_driver *driver, unsigned index,
+		struct device *device);
 extern int tty_port_alloc_xmit_buf(struct tty_port *port);
 extern void tty_port_free_xmit_buf(struct tty_port *port);
 extern void tty_port_put(struct tty_port *port);
-- 
1.7.10.3


