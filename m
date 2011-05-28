Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab1E1RhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:37:12 -0400
Received: from mail.perches.com ([173.55.12.10]:2211 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab1E1RhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:07 -0400
From: Joe Perches <joe@perches.com>
To: Neil Brown <neilb@suse.de>, Jiri Kosina <trivial@kernel.org>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH next 07/15] md: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:27 -0700
Message-Id: <3e09b436027e1d6f2a42663739961817da1e2be9.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/dm-log.c             |    3 +--
 drivers/md/dm-snap-persistent.c |    3 +--
 drivers/md/dm-table.c           |    4 +---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index a1f3218..b6c2b71 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -487,7 +487,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	memset(lc->sync_bits, (sync == NOSYNC) ? -1 : 0, bitset_size);
 	lc->sync_count = (sync == NOSYNC) ? region_count : 0;
 
-	lc->recovering_bits = vmalloc(bitset_size);
+	lc->recovering_bits = vzalloc(bitset_size);
 	if (!lc->recovering_bits) {
 		DMWARN("couldn't allocate sync bitset");
 		vfree(lc->sync_bits);
@@ -499,7 +499,6 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 		kfree(lc);
 		return -ENOMEM;
 	}
-	memset(lc->recovering_bits, 0, bitset_size);
 	lc->sync_search = 0;
 	log->context = lc;
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 95891df..be100d4 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -174,10 +174,9 @@ static int alloc_area(struct pstore *ps)
 	if (!ps->area)
 		goto err_area;
 
-	ps->zero_area = vmalloc(len);
+	ps->zero_area = vzalloc(len);
 	if (!ps->zero_area)
 		goto err_zero_area;
-	memset(ps->zero_area, 0, len);
 
 	ps->header_area = vmalloc(len);
 	if (!ps->header_area)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index cb8380c..5850497 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -154,9 +154,7 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size)
 		return NULL;
 
 	size = nmemb * elem_size;
-	addr = vmalloc(size);
-	if (addr)
-		memset(addr, 0, size);
+	addr = vzalloc(size);
 
 	return addr;
 }
-- 
1.7.5.rc3.dirty

