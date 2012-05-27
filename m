Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422677Ab2E0BQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:16:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422641Ab2E0BQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:16:54 -0400
Message-Id: <20120527002515.361144218@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:45 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [ 39/91] Add missing call to uart_update_timeout()
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lothar Waßmann <LW@KARO-electronics.de>

commit 8b979f7c6bf13a57e7b6002f1175312a44773960 upstream.

This patch fixes a problem reported here:
http://article.gmane.org/gmane.linux.ports.arm.kernel/155242/match=auart

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/mxs-auart.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -369,6 +369,8 @@ static void mxs_auart_settermios(struct
 
 	writel(ctrl, u->membase + AUART_LINECTRL);
 	writel(ctrl2, u->membase + AUART_CTRL2);
+
+	uart_update_timeout(u, termios->c_cflag, baud);
 }
 
 static irqreturn_t mxs_auart_irq_handle(int irq, void *context)


