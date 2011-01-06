Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1AFW3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:29:34 -0500
Received: from kroah.org ([198.145.64.141]:55649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab1AFWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/36] serial: mpc52xx: make printout for type more generic
Date: Thu,  6 Jan 2011 14:23:02 -0800
Message-Id: <1294352605-31906-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <w.sang@pengutronix.de>

The printout for the type should be just "5xxx", so 512x users won't
wonder why they have a mpc52xx-type UART.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mpc52xx_uart.c |    6 +++++-
 include/linux/serial_core.h   |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
index c4399e2..126ec7f 100644
--- a/drivers/serial/mpc52xx_uart.c
+++ b/drivers/serial/mpc52xx_uart.c
@@ -838,7 +838,11 @@ mpc52xx_uart_set_termios(struct uart_port *port, struct ktermios *new,
 static const char *
 mpc52xx_uart_type(struct uart_port *port)
 {
-	return port->type == PORT_MPC52xx ? "MPC52xx PSC" : NULL;
+	/*
+	 * We keep using PORT_MPC52xx for historic reasons although it applies
+	 * for MPC512x, too, but print "MPC5xxx" to not irritate users
+	 */
+	return port->type == PORT_MPC52xx ? "MPC5xxx PSC" : NULL;
 }
 
 static void
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 41603d6..9ff9b7d 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -95,7 +95,7 @@
 /* PPC CPM type number */
 #define PORT_CPM        58
 
-/* MPC52xx type numbers */
+/* MPC52xx (and MPC512x) type numbers */
 #define PORT_MPC52xx	59
 
 /* IBM icom */
-- 
1.7.3.2

