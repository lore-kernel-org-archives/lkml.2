Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1DOUvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:51:32 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:27759 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756233Ab1DOUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Mjw0H_4VM1kVGjaKjeZ9Mm3r.M.jF57r6JH.Dor3Mux6R4x
 lbg5RwDqHLnvOBAMqlQdGDJspZLY0wqpLwb2oJIqelgjbKgPK5ANsMWCfoa8
 pkqB8rPEz00A2RsbZl9rMlS72vABIXg8tDfcftrENtO8e08yDigws3igPm5z
 MSE_1HCoEwPF9fSFCZRE3E5Bvb0kRwbyLpK9UgjC18Avq.e7jTQ3dYiCvAMh
 gp5ps5sGKXgOTiwFhW.k7CQkGGtIXfszyZu5cfpHDAf0xVfg9yw7soFIzRor
 6AEtE1Hy_zJQ0zqyb3BjPbRruVZyHb2Sfax5fwlz0vJo24BRU6odVMPhzIEE
 -
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204748.949166441@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:35 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 05/21] slub: Move debug handlign in __slab_free
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=move_debug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its easier to read if its with the check for debugging flags.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 12:54:21.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 12:54:21.000000000 -0500
@@ -2057,10 +2057,9 @@ static void __slab_free(struct kmem_cach
 	slab_lock(page);
 	stat(s, FREE_SLOWPATH);
 
-	if (kmem_cache_debug(s))
-		goto debug;
+	if (kmem_cache_debug(s) && !free_debug_processing(s, page, x, addr))
+		goto out_unlock;
 
-checks_ok:
 	prior = page->freelist;
 	set_freepointer(s, object, prior);
 	page->freelist = object;
@@ -2104,12 +2103,6 @@ slab_empty:
 #endif
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
-	return;
-
-debug:
-	if (!free_debug_processing(s, page, x, addr))
-		goto out_unlock;
-	goto checks_ok;
 }
 
 /*

