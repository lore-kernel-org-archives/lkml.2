Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0IRTjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:39:10 -0400
Received: from kroah.org ([198.145.64.141]:43190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab0IRTOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:47 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:58 2010
Message-Id: <20100918191258.292092742@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [012/129] pata_cmd64x: revert commit d62f5576
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit aba8a08ded89a74f1ba04ae94ecc98f26e27d41c upstream.

Commit d62f5576 (pata_cmd64x: fix handling of address setup timings)
incorrectly called ata_timing_compute() on UDMA mode on 0 @UT leading
to devide by zero fault.  Revert it until better fix is available.
This is reported in bko#16607 by Milan Kocian who also root caused it.

  https://bugzilla.kernel.org/show_bug.cgi?id=16607

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-root-caused-by: Milan Kocian <milan.kocian@wq.cz>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_cmd64x.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -121,14 +121,8 @@ static void cmd64x_set_timing(struct ata
 
 		if (pair) {
 			struct ata_timing tp;
-
 			ata_timing_compute(pair, pair->pio_mode, &tp, T, 0);
 			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
-			if (pair->dma_mode) {
-				ata_timing_compute(pair, pair->dma_mode,
-						&tp, T, 0);
-				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
-			}
 		}
 	}
 


