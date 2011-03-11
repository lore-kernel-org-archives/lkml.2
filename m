Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1CKG6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 01:58:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41317 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1CKG6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 01:58:34 -0500
Date: Fri, 11 Mar 2011 17:58:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: linux-next: build failure after merge of the final tree (block tree
 related)
Message-Id: <20110311175830.29a387b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/char/tpm/tpm_tis.c:96: warning: 'is_itpm' defined but not used
drivers/block/drbd/drbd_bitmap.c: In function '__bm_change_bits_to':
drivers/block/drbd/drbd_bitmap.c:1287: error: implicit declaration of function 'generic___test_and_set_le_bit'
drivers/block/drbd/drbd_bitmap.c:1289: error: implicit declaration of function 'generic___test_and_clear_le_bit'
drivers/block/drbd/drbd_bitmap.c: In function 'drbd_bm_test_bit':
drivers/block/drbd/drbd_bitmap.c:1438: error: implicit declaration of function 'generic_test_le_bit'

Caused by commit 4b0715f09655 ("drbd: allow petabyte storage on 64bit
arch").

I have applied this patch for today (surely there is a better way):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 11 Mar 2011 17:54:54 +1100
Subject: [PATCH] drbd: need include for bitops functions declarations

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/block/drbd/drbd_bitmap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index b62dd5f..f0ae63d 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -28,6 +28,9 @@
 #include <linux/drbd.h>
 #include <linux/slab.h>
 #include <asm/kmap_types.h>
+
+#include <asm-generic/bitops/le.h>
+
 #include "drbd_int.h"
 
 
-- 
1.7.4.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
