Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab0HZNWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:22:33 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38426 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110Ab0HZNV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:27 -0400
Message-Id: <20100826132125.941181583@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:56 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 19/25] GRU - update debug messages and comments
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_misc_cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Misc clean:
	- update debug messages
	- update stale comments in the code


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufault.c     |    1 -
 drivers/misc/sgi-gru/grukservices.h |    3 +--
 drivers/misc/sgi-gru/grulib.h       |    1 -
 drivers/misc/sgi-gru/grumain.c      |   26 +++++++++++++-------------
 drivers/misc/sgi-gru/grutlbpurge.c  |    1 -
 5 files changed, 14 insertions(+), 18 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufault.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:45.803958078 -0500
+++ linux/drivers/misc/sgi-gru/grufault.c	2010-06-09 08:11:47.573040296 -0500
@@ -209,7 +209,6 @@ static int non_atomic_pte_lookup(struct
  *
  * Convert a user virtual address to a physical address
  * Only supports Intel large pages (2MB only) on x86_64.
- *	ZZZ - hugepage support is incomplete
  *
  * NOTE: mmap_sem is already held on entry to this function. This
  * guarantees existence of the page tables.
Index: linux/drivers/misc/sgi-gru/grukservices.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grukservices.h	2010-06-09 08:11:30.008045922 -0500
+++ linux/drivers/misc/sgi-gru/grukservices.h	2010-06-09 08:11:47.573040296 -0500
@@ -36,9 +36,8 @@
  * 	- multiple senders
  *	- cross partition message
  *
- * Missing features ZZZ:
+ * Missing features:
  * 	- user options for dealing with timeouts, queue full, etc.
- * 	- gru_create_message_queue() needs interrupt vector info
  */
 
 struct gru_message_queue_desc {
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2010-06-09 08:11:45.407956625 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2010-06-09 08:11:47.593081003 -0500
@@ -25,7 +25,6 @@
 
 /*
  * Maximum number of GRU segments that a user can have open
- * ZZZ temp - set high for testing. Revisit.
  */
 #define GRU_MAX_OPEN_CONTEXTS		32
 
Index: linux/drivers/misc/sgi-gru/grumain.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grumain.c	2010-06-09 08:11:46.261068458 -0500
+++ linux/drivers/misc/sgi-gru/grumain.c	2010-06-09 08:11:47.621041821 -0500
@@ -265,7 +265,7 @@ static int gru_load_mm_tracker(struct gr
 	spin_unlock(&gms->ms_asid_lock);
 
 	gru_dbg(grudev,
-		"gid %d, gts %p, gms %p, ctxnum %d, asid 0x%x, asidmap 0x%lx\n",
+		"gid %d, gts 0x%p, gms %p, ctxnum %d, asid 0x%x, asidmap 0x%lx\n",
 		gru->gs_gid, gts, gms, gts->ts_ctxnum, asid,
 		gms->ms_asidmap[0]);
 	return asid;
@@ -284,7 +284,7 @@ static void gru_unload_mm_tracker(struct
 	spin_lock(&gru->gs_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
-	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
+	gru_dbg(grudev, "gid %d, gts 0x%p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
 		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
 	spin_unlock(&gru->gs_asid_lock);
 	spin_unlock(&gms->ms_asid_lock);
@@ -350,12 +350,12 @@ struct gru_thread_state *gru_alloc_gts(s
 	if (vma) {
 		struct gru_vma_data *vdata = vma->vm_private_data;
 
-		gts->ts_gms = vdata->vd_gms;;
+		gts->ts_gms = vdata->vd_gms;
 		gts->ts_mm = current->mm;
 		gts->ts_vma = vma;
 	}
 
-	gru_dbg(grudev, "alloc gts %p\n", gts);
+	gru_dbg(grudev, "alloc gts 0x%p\n", gts);
 	return gts;
 }
 
@@ -399,7 +399,7 @@ struct gru_thread_state *gru_find_thread
 	spin_lock(&vdata->vd_lock);
 	gts = gru_find_current_gts_nolock(vdata, tsid);
 	spin_unlock(&vdata->vd_lock);
-	gru_dbg(grudev, "vma %p, gts %p\n", vma, gts);
+	gru_dbg(grudev, "vma %p, gts 0x%p\n", vma, gts);
 	return gts;
 }
 
@@ -430,7 +430,7 @@ struct gru_thread_state *gru_alloc_threa
 		list_add(&gts->ts_next, &vdata->vd_head);
 	}
 	spin_unlock(&vdata->vd_lock);
-	gru_dbg(grudev, "vma %p, gts %p\n", vma, gts);
+	gru_dbg(grudev, "vma %p, gts 0x%p\n", vma, gts);
 	return gts;
 }
 
@@ -442,7 +442,7 @@ static void gru_free_gru_context(struct
 	struct gru_state *gru;
 
 	gru = gts->ts_gru;
-	gru_dbg(grudev, "gts %p, gid %d\n", gts, gru->gs_gid);
+	gru_dbg(grudev, "gts 0x%p, gid %d\n", gts, gru->gs_gid);
 
 	spin_lock(&gru->gs_lock);
 	gru->gs_gts[gts->ts_ctxnum] = NULL;
@@ -565,7 +565,7 @@ void gru_unload_context(struct gru_threa
 		zap_vma_ptes(gts->ts_vma, UGRUADDR(gts), GRU_GSEG_PAGESIZE);
 	cch = get_cch(gru->gs_gru_base_vaddr, ctxnum);
 
-	gru_dbg(grudev, "gts %p, cbrmap 0x%lx, dsrmap 0x%lx\n",
+	gru_dbg(grudev, "gts 0x%p, cbrmap 0x%lx, dsrmap 0x%lx\n",
 		gts, gts->ts_cbr_map, gts->ts_dsr_map);
 	lock_cch_handle(cch);
 	if (cch_interrupt_sync(cch))
@@ -633,7 +633,7 @@ void gru_load_context(struct gru_thread_
 	err = cch_allocate(cch);
 	if (err) {
 		gru_dbg(grudev,
-			"err %d: cch %p, gts %p, cbr 0x%lx, dsr 0x%lx\n",
+			"err %d: cch %p, gts 0x%p, cbr 0x%lx, dsr 0x%lx\n",
 			err, cch, gts, gts->ts_cbr_map, gts->ts_dsr_map);
 		BUG();
 	}
@@ -645,7 +645,7 @@ void gru_load_context(struct gru_thread_
 		BUG();
 	unlock_cch_handle(cch);
 
-	gru_dbg(grudev, "gid %d, gts %p, cbrmap 0x%lx, dsrmap 0x%lx, tie %d, tis %d\n",
+	gru_dbg(grudev, "gid %d, gts 0x%p, cbrmap 0x%lx, dsrmap 0x%lx, tie %d, tis %d\n",
 		gts->ts_gru->gs_gid, gts, gts->ts_cbr_map, gts->ts_dsr_map,
 		(gts->ts_user_options == GRU_OPT_MISS_FMM_INTR), gts->ts_tlb_int_select);
 }
@@ -851,7 +851,7 @@ void gru_steal_context(struct gru_thread
 		STAT(steal_context_failed);
 	}
 	gru_dbg(grudev,
-		"stole gid %d, ctxnum %d from gts %p. Need cb %d, ds %d;"
+		"stole gid %d, ctxnum %d from gts 0x%p. Need cb %d, ds %d;"
 		" avail cb %ld, ds %ld\n",
 		gru->gs_gid, ctxnum, ngts, cbr, dsr, hweight64(gru->gs_cbr_map),
 		hweight64(gru->gs_dsr_map));
@@ -913,8 +913,8 @@ again:
 
 		STAT(assign_context);
 		gru_dbg(grudev,
-			"gseg %p, gts %p, gid %d, ctx %d, cbr %d, dsr %d\n",
-			gseg_virtual_address(gts->ts_gru, gts->ts_ctxnum), gts,
+			"gseg %p, pid %d, gts 0x%p, gid %d, ctx %d, cbr %d, dsr %d\n",
+			gseg_virtual_address(gts->ts_gru, gts->ts_ctxnum), current->pid, gts,
 			gts->ts_gru->gs_gid, gts->ts_ctxnum,
 			gts->ts_cbr_au_count, gts->ts_dsr_au_count);
 	} else {
Index: linux/drivers/misc/sgi-gru/grutlbpurge.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutlbpurge.c	2010-06-09 08:11:43.772080689 -0500
+++ linux/drivers/misc/sgi-gru/grutlbpurge.c	2010-06-09 08:11:47.645042345 -0500
@@ -162,7 +162,6 @@ void gru_flush_tlb_range(struct gru_mm_s
 	unsigned long num;
 	int grupagesize, pagesize, pageshift, gid, asid;
 
-	/* ZZZ TODO - handle huge pages */
 	pageshift = PAGE_SHIFT;
 	pagesize = (1UL << pageshift);
 	grupagesize = GRU_PAGESIZE(pageshift);

