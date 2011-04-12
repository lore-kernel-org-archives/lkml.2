Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1DLIEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:04:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:50973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab1DLIEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:04:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,194,1301900400"; 
   d="scan'208";a="627241458"
Subject: [PATCH 2/4]percpu_counter: use correct API
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 16:04:01 +0800
Message-ID: <1302595441.3981.128.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter_sum_positive never returns negative, since there
is a negative check, I changed it to percpu_counter_sum.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/ext4/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/ext4/balloc.c
===================================================================
--- linux.orig/fs/ext4/balloc.c	2011-04-12 15:48:42.000000000 +0800
+++ linux/fs/ext4/balloc.c	2011-04-12 15:48:50.000000000 +0800
@@ -506,7 +506,7 @@ static int ext4_has_free_blocks(struct e
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
 		free_blocks  = percpu_counter_sum_positive(fbc);
-		dirty_blocks = percpu_counter_sum_positive(dbc);
+		dirty_blocks = percpu_counter_sum(dbc);
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",


