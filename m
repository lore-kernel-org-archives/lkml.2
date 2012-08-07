Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2HGT4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:56:44 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49889 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab2HGT4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:56:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 24/41] TTY: tty_port, add some documentation
Date: Tue,  7 Aug 2012 21:47:49 +0200
Message-Id: <1344368886-24033-25-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to document tty_port_register_device and tty_port_install
when they were added. Fix it now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_port.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index edcb827..b36b33a 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -33,6 +33,17 @@ void tty_port_init(struct tty_port *port)
 }
 EXPORT_SYMBOL(tty_port_init);
 
+/**
+ * tty_port_register_device - register tty device
+ * @port: tty_port of the device
+ * @driver: tty_driver for this device
+ * @index: index of the tty
+ * @device: parent if exists, otherwise NULL
+ *
+ * It is the same as tty_register_device except the provided @port is linked to
+ * a concrete tty specified by @index. Use this or tty_port_install (or both).
+ * Call tty_port_link_device as a last resort.
+ */
 struct device *tty_port_register_device(struct tty_port *port,
 		struct tty_driver *driver, unsigned index,
 		struct device *device)
@@ -422,6 +433,16 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 }
 EXPORT_SYMBOL(tty_port_close);
 
+/**
+ * tty_port_install - generic tty->ops->install handler
+ * @port: tty_port of the device
+ * @driver: tty_driver for this device
+ * @tty: tty to be installed
+ *
+ * It is the same as tty_standard_install except the provided @port is linked
+ * to a concrete tty specified by @tty. Use this or tty_port_register_device
+ * (or both). Call tty_port_link_device as a last resort.
+ */
 int tty_port_install(struct tty_port *port, struct tty_driver *driver,
 		struct tty_struct *tty)
 {
-- 
1.7.10.4


