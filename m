Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0KHX6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:58:07 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:55514 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab0KHX6G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:58:06 -0500
Date: Mon, 8 Nov 2010 15:58:01 -0800
From: Andres Salomon <dilinger@queued.net>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: [PATCH] pcmcia: fix warning in synclink driver
Message-ID: <20101108155801.0c78f2d2@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During builds I see the following warning -

  CC [M]  drivers/char/pcmcia/synclink_cs.o
drivers/char/pcmcia/synclink_cs.c:2194: warning: ‘mgslpc_get_icount’ defined but not used

The function is a callback meant to be assigned to get_icount (added during 0587102cf).
Fix accordingly.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/char/pcmcia/synclink_cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index bfc10f8..eaa4199 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2796,6 +2796,7 @@ static const struct tty_operations mgslpc_ops = {
 	.hangup = mgslpc_hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.get_icount = mgslpc_get_icount,
 	.proc_fops = &mgslpc_proc_fops,
 };
 
-- 
1.7.1

