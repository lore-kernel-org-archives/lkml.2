Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2DBL46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:58 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48221 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2DBLzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 43/69] TTY: hvsi, CLOCAL is not in tty->flags
Date: Mon,  2 Apr 2012 13:54:27 +0200
Message-Id: <1333367693-3244-44-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is in termios cflags. So change the test in hvsi_recv_control to do
the right thing. Previously it was actually testing TTY_LDISC_OPEN
bit, i.e. whether an ldisc is active. And yes, it is most of the time.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index a7488b7..4006aed 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -248,7 +248,7 @@ static void hvsi_recv_control(struct hvsi_struct *hp, uint8_t *packet,
 				pr_debug("hvsi%i: CD dropped\n", hp->index);
 				hp->mctrl &= TIOCM_CD;
 				/* If userland hasn't done an open(2) yet, hp->tty is NULL. */
-				if (hp->tty && !(hp->tty->flags & CLOCAL))
+				if (hp->tty && !C_CLOCAL(hp->tty))
 					*to_hangup = hp->tty;
 			}
 			break;
-- 
1.7.9.2


