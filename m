Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2LPVBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 16:01:00 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45010 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2LPVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 16:00:59 -0500
Date: Sun, 16 Dec 2012 22:00:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia/vrc4171: Add missing spinlock init
Message-ID: <20121216220050.7b955a19@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't seem this spinlock was properly initialized. This bug was
introduced by commit 7a410e8d4d97457c8c381e2de9cdc7bd3306badc.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
I can't even build-test this. Already sent on:
 * 2012-09-06

 drivers/pcmcia/vrc4171_card.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-3.6-rc4.orig/drivers/pcmcia/vrc4171_card.c	2012-07-21 22:58:29.000000000 +0200
+++ linux-3.6-rc4/drivers/pcmcia/vrc4171_card.c	2012-09-06 14:07:40.976007788 +0200
@@ -246,6 +246,7 @@ static int pccard_init(struct pcmcia_soc
 	socket = &vrc4171_sockets[slot];
 	socket->csc_irq = search_nonuse_irq();
 	socket->io_irq = search_nonuse_irq();
+	spin_lock_init(&socket->lock);
 
 	return 0;
 }


-- 
Jean Delvare
