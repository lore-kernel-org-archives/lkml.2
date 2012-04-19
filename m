Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab2DSQMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:12:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:45357 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215Ab2DSQMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:12:48 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/tty/amiserial.c: add missing tty_unlock
Date: Thu, 19 Apr 2012 18:12:40 +0200
Message-Id: <1334851960-29409-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

tty_unlock is used on all other exits from the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/tty/amiserial.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 24145c3..6cc4358 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1073,8 +1073,10 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 		    (new_serial.close_delay != port->close_delay) ||
 		    (new_serial.xmit_fifo_size != state->xmit_fifo_size) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
-		     (port->flags & ~ASYNC_USR_MASK)))
+		     (port->flags & ~ASYNC_USR_MASK))) {
+			tty_unlock();
 			return -EPERM;
+		}
 		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
 			       (new_serial.flags & ASYNC_USR_MASK));
 		state->custom_divisor = new_serial.custom_divisor;

