Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab0IYLhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 07:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503Ab0IYLg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 07:36:58 -0400
Date: Sat, 25 Sep 2010 07:36:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: linux-m68k@vger.kernel.org
Subject: [PATCH] amiga floppy: Compile failure fixes
Message-ID: <20100925113652.GA20016@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I did cross compile for m68k and noticed amiga floppy driver failed to
compile with my patch. Please find attached the fix.

I had sent same patch in original mail thread. Resending it in a separate
mail.

Thanks
Vivek


o Compile fixes for amiga floppy driver.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/amiflop.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6-block/drivers/block/amiflop.c
===================================================================
--- linux-2.6-block.orig/drivers/block/amiflop.c	2010-09-24 16:12:19.000000000 -0400
+++ linux-2.6-block/drivers/block/amiflop.c	2010-09-24 16:13:38.000000000 -0400
@@ -1347,12 +1347,12 @@ static struct request *set_next_request(
 	if (fdc_queue == FD_MAX_UNITS)
 		fdc_queue = 0;
 
-	for(cnt = FD_MAX_UNITS; cnt > 0, cnt--) {
+	for(cnt = FD_MAX_UNITS; cnt > 0; cnt--) {
 
 		if (unit[fdc_queue].type->code == FD_NODRIVE) {
 			if (++fdc_queue == FD_MAX_UNITS)
 				fdc_queue = 0;
-			cotinue;
+			continue;
 		}
 
 		q = unit[fdc_queue].gendisk->queue;
@@ -1827,7 +1827,6 @@ static int __init amiga_floppy_probe(str
 	return 0;
 
 out_probe:
-out_queue:
 	free_irq(IRQ_AMIGA_CIAA_TB, NULL);
 out_irq2:
 	free_irq(IRQ_AMIGA_DSKBLK, NULL);
