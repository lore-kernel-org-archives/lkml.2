Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3ACM0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:26:03 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:59449 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3ACMTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:19:51 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-mm@kvack.org
Subject: [PATCH -v2 06/26] mm/: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:02 +0900
Message-Id: <1357215562-6288-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-mm@kvack.org
---

No change from v1

 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index e97a0e5..3af83bf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2044,7 +2044,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (p->bdev) {
 		if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 			p->flags |= SWP_SOLIDSTATE;
-			p->cluster_next = 1 + (random32() % p->highest_bit);
+			p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
 		}
 		if ((swap_flags & SWAP_FLAG_DISCARD) && discard_swap(p) == 0)
 			p->flags |= SWP_DISCARDABLE;
-- 
1.7.11.7

