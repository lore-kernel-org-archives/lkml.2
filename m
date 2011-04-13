Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab1DMIFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:05:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:12504 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544Ab1DMIFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:05:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="418330578"
Message-Id: <20110413080517.566936500@sli10-conroe.sh.intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 15:57:17 +0800
From: shaohua.li@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux.com, tj@kernel.org,
        eric.dumazet@gmail.com, Shaohua Li <shaohua.li@intel.com>
Subject: [patch v2 2/4] percpu_counter: delete dead code
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
Content-Disposition: inline; filename=percpu-counter-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter_sum_positive never returns negative.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/ext4/balloc.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux/fs/ext4/balloc.c
===================================================================
--- linux.orig/fs/ext4/balloc.c	2011-04-12 16:22:59.000000000 +0800
+++ linux/fs/ext4/balloc.c	2011-04-13 13:23:01.000000000 +0800
@@ -507,11 +507,6 @@ static int ext4_has_free_blocks(struct e
 						EXT4_FREEBLOCKS_WATERMARK) {
 		free_blocks  = percpu_counter_sum_positive(fbc);
 		dirty_blocks = percpu_counter_sum_positive(dbc);
-		if (dirty_blocks < 0) {
-			printk(KERN_CRIT "Dirty block accounting "
-					"went wrong %lld\n",
-					(long long)dirty_blocks);
-		}
 	}
 	/* Check whether we have space after
 	 * accounting for current dirty blocks & root reserved blocks.

