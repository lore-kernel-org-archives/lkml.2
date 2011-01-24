Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab1AXQxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 11:53:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40645 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab1AXQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 11:53:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KDEHorcfmZUC8arUjgOjPkQ9nGF0Zq9PSZzABgXX7xusaZWMc9MA4GwtWBUAakCwFT
         VhW2v0Bo6mjD+Gm6KoDf4c80G0qSZ8086vJCPab/RYypotT+2mH/z25vJFTX3HLVtAY6
         gLXxROeUrtvX9Jrfy2sYKTR+FWPv6qu4EB1N0=
Date: Mon, 24 Jan 2011 17:53:41 +0100
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <greg@kroah.com>, Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 68328serial: remove unsed m68k_serial->tqueue_hangup
Message-ID: <20110124165341.GE27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k_serial->tqueue_hangup is unused.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>
---
 drivers/tty/serial/68328serial.c |   23 -----------------------
 drivers/tty/serial/68328serial.h |    1 -
 2 files changed, 24 deletions(-)

Index: work/drivers/tty/serial/68328serial.c
===================================================================
--- work.orig/drivers/tty/serial/68328serial.c
+++ work/drivers/tty/serial/68328serial.c
@@ -393,28 +393,6 @@ static void do_softint(struct work_struc
 #endif   
 }
 
-/*
- * This routine is called from the scheduler tqueue when the interrupt
- * routine has signalled that a hangup has occurred.  The path of
- * hangup processing is:
- *
- * 	serial interrupt routine -> (scheduler tqueue) ->
- * 	do_serial_hangup() -> tty->hangup() -> rs_hangup()
- * 
- */
-static void do_serial_hangup(struct work_struct *work)
-{
-	struct m68k_serial	*info = container_of(work, struct m68k_serial, tqueue_hangup);
-	struct tty_struct	*tty;
-	
-	tty = info->port.tty;
-	if (!tty)
-		return;
-
-	tty_hangup(tty);
-}
-
-
 static int startup(struct m68k_serial * info)
 {
 	m68328_uart *uart = &uart_addr[info->line];
@@ -1348,7 +1326,6 @@ rs68328_init(void)
 	    info->count = 0;
 	    info->blocked_open = 0;
 	    INIT_WORK(&info->tqueue, do_softint);
-	    INIT_WORK(&info->tqueue_hangup, do_serial_hangup);
 	    init_waitqueue_head(&info->open_wait);
 	    init_waitqueue_head(&info->close_wait);
 	    info->line = i;
Index: work/drivers/tty/serial/68328serial.h
===================================================================
--- work.orig/drivers/tty/serial/68328serial.h
+++ work/drivers/tty/serial/68328serial.h
@@ -159,7 +159,6 @@ struct m68k_serial {
 	int			xmit_tail;
 	int			xmit_cnt;
 	struct work_struct	tqueue;
-	struct work_struct	tqueue_hangup;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 };
