Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678Ab2AFOBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:01:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36246 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2AFOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:01:06 -0500
MIME-Version: 1.0
Date: Fri, 6 Jan 2012 22:01:03 +0800
Message-ID: <CAJd=RBBifQggNFtBsq0-Q_fG6mOJ-rJ544Me9pLFXbMi3Xn0gQ@mail.gmail.com>
Subject: [PATCH] mm: vmscan: cleanup with s/reclaim_mode/isolate_mode/
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With tons of reclaim_mode(defined as one field of struct scan_control) already
in the file, it is clearer to rename it when setting up the isolation mode.


Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
+++ b/mm/vmscan.c	Fri Jan  6 21:53:48 2012
@@ -1541,7 +1541,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_file;
 	unsigned long nr_dirty = 0;
 	unsigned long nr_writeback = 0;
-	isolate_mode_t reclaim_mode = ISOLATE_INACTIVE;
+	isolate_mode_t isolate_mode = ISOLATE_INACTIVE;
 	struct zone *zone = mz->zone;

 	while (unlikely(too_many_isolated(zone, file, sc))) {
@@ -1554,20 +1554,20 @@ shrink_inactive_list(unsigned long nr_to

 	set_reclaim_mode(priority, sc, false);
 	if (sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM)
-		reclaim_mode |= ISOLATE_ACTIVE;
+		isolate_mode |= ISOLATE_ACTIVE;

 	lru_add_drain();

 	if (!sc->may_unmap)
-		reclaim_mode |= ISOLATE_UNMAPPED;
+		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
-		reclaim_mode |= ISOLATE_CLEAN;
+		isolate_mode |= ISOLATE_CLEAN;

 	spin_lock_irq(&zone->lru_lock);

 	nr_taken = isolate_pages(nr_to_scan, mz, &page_list,
 				 &nr_scanned, sc->order,
-				 reclaim_mode, 0, file);
+				 isolate_mode, 0, file);
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1705,21 +1705,21 @@ static void shrink_active_list(unsigned
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	unsigned long nr_rotated = 0;
-	isolate_mode_t reclaim_mode = ISOLATE_ACTIVE;
+	isolate_mode_t isolate_mode = ISOLATE_ACTIVE;
 	struct zone *zone = mz->zone;

 	lru_add_drain();

 	if (!sc->may_unmap)
-		reclaim_mode |= ISOLATE_UNMAPPED;
+		isolate_mode |= ISOLATE_UNMAPPED;
 	if (!sc->may_writepage)
-		reclaim_mode |= ISOLATE_CLEAN;
+		isolate_mode |= ISOLATE_CLEAN;

 	spin_lock_irq(&zone->lru_lock);

 	nr_taken = isolate_pages(nr_pages, mz, &l_hold,
 				 &pgscanned, sc->order,
-				 reclaim_mode, 1, file);
+				 isolate_mode, 1, file);

 	if (global_reclaim(sc))
 		zone->pages_scanned += pgscanned;
