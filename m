Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1G0WA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:00:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:18770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab1G0VtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900795"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: namhyung@gmail.com, neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [56/99] md/raid5: fix raid5_set_bi_hw_segments
Message-Id: <20110727214855.530AD2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Namhyung Kim <namhyung@gmail.com>

commit 9b2dc8b665932a8e681a7ab3237f60475e75e161 upstream.

The @bio->bi_phys_segments consists of active stripes count in the
lower 16 bits and processed stripes count in the upper 16 bits. So
logical-OR operator should be bitwise one.

This bug has been present since 2.6.27 and the fix is suitable for any
-stable kernel since then.  Fortunately the bad code is only used on
error paths and is relatively unlikely to be hit.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/md/raid5.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/raid5.c
+++ linux-2.6.35.y/drivers/md/raid5.c
@@ -129,7 +129,7 @@ static inline int raid5_dec_bi_hw_segmen
 
 static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
+	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
 }
 
 /* Find first data disk in a raid6 stripe */
