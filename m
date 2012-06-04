Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2FDLfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:35:46 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44991 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 18/24] TTY: provide drivers with tty_port_install
Date: Mon,  4 Jun 2012 13:35:32 +0200
Message-Id: <1338809738-18967-19-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used in tty_ops->install to set tty->port (and to call
tty_standard_install).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_port.c |    8 ++++++++
 include/linux/tty.h    |    2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index bf6e238..1ac8abf 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -413,6 +413,14 @@ void tty_port_close(struct tty_port *port, struct tty_struct *tty,
 }
 EXPORT_SYMBOL(tty_port_close);
 
+int tty_port_install(struct tty_port *port, struct tty_driver *driver,
+		struct tty_struct *tty)
+{
+	tty->port = port;
+	return tty_standard_install(driver, tty);
+}
+EXPORT_SYMBOL_GPL(tty_port_install);
+
 int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 							struct file *filp)
 {
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f47ab5..45ef71d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -521,6 +521,8 @@ extern int tty_port_close_start(struct tty_port *port,
 extern void tty_port_close_end(struct tty_port *port, struct tty_struct *tty);
 extern void tty_port_close(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
+extern int tty_port_install(struct tty_port *port, struct tty_driver *driver,
+				struct tty_struct *tty);
 extern int tty_port_open(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
 static inline int tty_port_users(struct tty_port *port)
-- 
1.7.10.3


