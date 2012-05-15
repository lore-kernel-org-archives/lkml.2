Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965952Ab2EODDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:03:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:49433 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930Ab2EOCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 065/179] md/raid5: fix raid5_set_bi_hw_segments
Date: Mon, 14 May 2012 22:12:41 -0400
Message-ID: <1337048075-6132-66-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9b2dc8b665932a8e681a7ab3237f60475e75e161 upstream.

The @bio->bi_phys_segments consists of active stripes count in the
lower 16 bits and processed stripes count in the upper 16 bits. So
logical-OR operator should be bitwise one.

This bug has been present since 2.6.27 and the fix is suitable for any
-stable kernel since then.  Fortunately the bad code is only used on
error paths and is relatively unlikely to be hit.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6af0a6d..de7984d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -128,7 +128,7 @@ static inline int raid5_dec_bi_hw_segments(struct bio *bio)
 
 static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
+	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
 }
 
 /* Find first data disk in a raid6 stripe */
-- 
1.7.9.6

