Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab1AWJGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 04:06:33 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:41626 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1AWJG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 04:06:28 -0500
Date: Sun, 23 Jan 2011 10:06:26 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <axboe@kernel.dk>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k/block: amiflop - Remove superfluous amiga_chip_alloc()
 cast
Message-ID: <alpine.DEB.2.00.1101231005430.3513@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amiga_chip_alloc() returns a void *, so we don't need a cast.
Also clean up coding style while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/amiflop.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 7888501..363855c 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1768,8 +1768,8 @@ static int __init amiga_floppy_probe(struct platform_device *pdev)
 		return -EBUSY;
 
 	ret = -ENOMEM;
-	if ((raw_buf = (char *)amiga_chip_alloc (RAW_BUF_SIZE, "Floppy")) ==
-	    NULL) {
+	raw_buf = amiga_chip_alloc(RAW_BUF_SIZE, "Floppy");
+	if (!raw_buf) {
 		printk("fd: cannot get chip mem buffer\n");
 		goto out_blkdev;
 	}
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
