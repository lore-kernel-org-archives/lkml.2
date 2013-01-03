Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3ACMYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:24:51 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56311 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3ACMUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:04 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Subject: [PATCH -v2 13/26] ubifs: rename random32() to prandom_u32()
Date: Thu,  3 Jan 2013 21:19:09 +0900
Message-Id: <1357215562-6288-14-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
---

No change from v1

 fs/ubifs/debug.c      |  8 ++++----
 fs/ubifs/lpt_commit.c | 14 +++++++-------
 fs/ubifs/tnc_commit.c |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 12817ff..7f60e90 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2459,7 +2459,7 @@ error_dump:
 
 static inline int chance(unsigned int n, unsigned int out_of)
 {
-	return !!((random32() % out_of) + 1 <= n);
+	return !!((prandom_u32() % out_of) + 1 <= n);
 
 }
 
@@ -2477,13 +2477,13 @@ static int power_cut_emulated(struct ubifs_info *c, int lnum, int write)
 			if (chance(1, 2)) {
 				d->pc_delay = 1;
 				/* Fail withing 1 minute */
-				delay = random32() % 60000;
+				delay = prandom_u32() % 60000;
 				d->pc_timeout = jiffies;
 				d->pc_timeout += msecs_to_jiffies(delay);
 				ubifs_warn("failing after %lums", delay);
 			} else {
 				d->pc_delay = 2;
-				delay = random32() % 10000;
+				delay = prandom_u32() % 10000;
 				/* Fail within 10000 operations */
 				d->pc_cnt_max = delay;
 				ubifs_warn("failing after %lu calls", delay);
@@ -2563,7 +2563,7 @@ static int corrupt_data(const struct ubifs_info *c, const void *buf,
 	unsigned int from, to, ffs = chance(1, 2);
 	unsigned char *p = (void *)buf;
 
-	from = random32() % (len + 1);
+	from = prandom_u32() % (len + 1);
 	/* Corruption may only span one max. write unit */
 	to = min(len, ALIGN(from, c->max_write_size));
 
diff --git a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
index 9daaeef..4b826ab 100644
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -2007,28 +2007,28 @@ static int dbg_populate_lsave(struct ubifs_info *c)
 
 	if (!dbg_is_chk_gen(c))
 		return 0;
-	if (random32() & 3)
+	if (prandom_u32() & 3)
 		return 0;
 
 	for (i = 0; i < c->lsave_cnt; i++)
 		c->lsave[i] = c->main_first;
 
 	list_for_each_entry(lprops, &c->empty_list, list)
-		c->lsave[random32() % c->lsave_cnt] = lprops->lnum;
+		c->lsave[prandom_u32() % c->lsave_cnt] = lprops->lnum;
 	list_for_each_entry(lprops, &c->freeable_list, list)
-		c->lsave[random32() % c->lsave_cnt] = lprops->lnum;
+		c->lsave[prandom_u32() % c->lsave_cnt] = lprops->lnum;
 	list_for_each_entry(lprops, &c->frdi_idx_list, list)
-		c->lsave[random32() % c->lsave_cnt] = lprops->lnum;
+		c->lsave[prandom_u32() % c->lsave_cnt] = lprops->lnum;
 
 	heap = &c->lpt_heap[LPROPS_DIRTY_IDX - 1];
 	for (i = 0; i < heap->cnt; i++)
-		c->lsave[random32() % c->lsave_cnt] = heap->arr[i]->lnum;
+		c->lsave[prandom_u32() % c->lsave_cnt] = heap->arr[i]->lnum;
 	heap = &c->lpt_heap[LPROPS_DIRTY - 1];
 	for (i = 0; i < heap->cnt; i++)
-		c->lsave[random32() % c->lsave_cnt] = heap->arr[i]->lnum;
+		c->lsave[prandom_u32() % c->lsave_cnt] = heap->arr[i]->lnum;
 	heap = &c->lpt_heap[LPROPS_FREE - 1];
 	for (i = 0; i < heap->cnt; i++)
-		c->lsave[random32() % c->lsave_cnt] = heap->arr[i]->lnum;
+		c->lsave[prandom_u32() % c->lsave_cnt] = heap->arr[i]->lnum;
 
 	return 1;
 }
diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index 523bbad..52a6559 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -683,7 +683,7 @@ static int alloc_idx_lebs(struct ubifs_info *c, int cnt)
 		c->ilebs[c->ileb_cnt++] = lnum;
 		dbg_cmt("LEB %d", lnum);
 	}
-	if (dbg_is_chk_index(c) && !(random32() & 7))
+	if (dbg_is_chk_index(c) && !(prandom_u32() & 7))
 		return -ENOSPC;
 	return 0;
 }
-- 
1.7.11.7

