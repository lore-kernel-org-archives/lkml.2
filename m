Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2E1D3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52016 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753824Ab2E1D30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:26 -0400
Message-Id: <20120528031209.381121063@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 047/117] Add missing call to uart_update_timeout()
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lothar Waßmann <LW@KARO-electronics.de>

commit 8b979f7c6bf13a57e7b6002f1175312a44773960 upstream.

This patch fixes a problem reported here:
http://article.gmane.org/gmane.linux.ports.arm.kernel/155242/match=auart

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/mxs-auart.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 55fd362..039c054 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -369,6 +369,8 @@ static void mxs_auart_settermios(struct uart_port *u,
 
 	writel(ctrl, u->membase + AUART_LINECTRL);
 	writel(ctrl2, u->membase + AUART_CTRL2);
+
+	uart_update_timeout(u, termios->c_cflag, baud);
 }
 
 static irqreturn_t mxs_auart_irq_handle(int irq, void *context)


