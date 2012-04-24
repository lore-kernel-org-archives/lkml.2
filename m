Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab2DXWfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:35:52 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33944 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab2DXWft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:35:49 -0400
Message-Id: <20120424223245.143471638@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Julia Lawall <Julia.Lawall@lip6.fr>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 37/62] drivers/tty/amiserial.c: add missing tty_unlock
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@lip6.fr>

commit d3a7b83f865b46bb7b5e1ed18a129ce1af349db4 upstream.

tty_unlock is used on all other exits from the function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/amiserial.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1113,8 +1113,10 @@ static int set_serial_info(struct async_
 		    (new_serial.close_delay != state->close_delay) ||
 		    (new_serial.xmit_fifo_size != state->xmit_fifo_size) ||
 		    ((new_serial.flags & ~ASYNC_USR_MASK) !=
-		     (state->flags & ~ASYNC_USR_MASK)))
+		     (state->flags & ~ASYNC_USR_MASK))) {
+			tty_unlock();
 			return -EPERM;
+		}
 		state->flags = ((state->flags & ~ASYNC_USR_MASK) |
 			       (new_serial.flags & ASYNC_USR_MASK));
 		info->flags = ((info->flags & ~ASYNC_USR_MASK) |


