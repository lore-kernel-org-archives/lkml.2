Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab2IFLsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:48:42 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:1519 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2IFLsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:48:41 -0400
Date: Thu, 6 Sep 2012 13:48:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] swim: Add missing spinlock init
Message-ID: <20120906134830.52cbdfec@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't seem this spinlock was properly initialized.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
I can't even build-test this.

 drivers/block/swim.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.6-rc4.orig/drivers/block/swim.c	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.6-rc4/drivers/block/swim.c	2012-09-06 13:09:26.713382169 +0200
@@ -845,6 +845,7 @@ static int __devinit swim_floppy_init(st
 		swd->unit[drive].swd = swd;
 	}
 
+	spin_lock_init(&swd->lock);
 	swd->queue = blk_init_queue(do_fd_request, &swd->lock);
 	if (!swd->queue) {
 		err = -ENOMEM;


-- 
Jean Delvare
