Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab2EGTgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:36:20 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:41387 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab2EGTgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:36:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] tty/amiserial: Add missing argument for tty_unlock()
Date: Mon,  7 May 2012 21:36:06 +0200
Message-Id: <1336419366-23555-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d29f3ef39be4eec0362b985305fc526d9be318cf ("tty_lock: Localise the lock")
missed that d3a7b83f865b46bb7b5e1ed18a129ce1af349db4 ("drivers/tty/amiserial.c:
add missing tty_unlock") just added a new caller of tty_unlock():

drivers/tty/amiserial.c: In function ‘set_serial_info’:
drivers/tty/amiserial.c:1077: error: too few arguments to function ‘tty_unlock’

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/6271985/

 drivers/tty/amiserial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index b88a65c..35819e3 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1074,7 +1074,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_state *state,
 		    (new_serial.xmit_fifo_size != state->xmit_fifo_size) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (port->flags & ~ASYNC_USR_MASK))) {
-			tty_unlock();
+			tty_unlock(tty);
 			return -EPERM;
 		}
 		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
-- 
1.7.0.4

