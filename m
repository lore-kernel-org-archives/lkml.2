Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993064Ab2KOIuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:50:10 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58345 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992996Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 1/9] TTY: isicom, stop using port->tty
Date: Thu, 15 Nov 2012 09:49:48 +0100
Message-Id: <1352969396-23760-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not access unsafe port->tty pointer when we have a safe tty
already. Use the safe one.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/isicom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index d7492e1..5f3ecbc 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -603,7 +603,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 			if (tty_port_cts_enabled(&port->port)) {
 				if (tty->hw_stopped) {
 					if (header & ISI_CTS) {
-						port->port.tty->hw_stopped = 0;
+						tty->hw_stopped = 0;
 						/* start tx ing */
 						port->status |= (ISI_TXOK
 							| ISI_CTS);
-- 
1.8.0


