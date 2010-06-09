Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0FISzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:55:47 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213Ab0FISyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:19 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183625.285489821@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:52 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] floppy: silence warning during disk test
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-quiet.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first thing the floppy does is read block 0 to test geometry
and to test for disk presence. If disk is not present this causes a
console warning message about failed I/O.  Set flag to silence.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/block/floppy.c	2010-06-08 14:54:39.187135875 -0700
+++ b/drivers/block/floppy.c	2010-06-08 14:54:40.307241699 -0700
@@ -3829,6 +3829,7 @@ static int __floppy_read_block_0(struct 
 	bio.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;
+	bio.bi_flags = BIO_QUIET;
 	init_completion(&complete);
 	bio.bi_private = &complete;
 	bio.bi_end_io = floppy_rb0_complete;


