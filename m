Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1HIVN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:13:59 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:37829 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752879Ab1HIVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:13:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6GGVwgIVM1nmAELOEXRGF0hR3PJvet3JmhbQaIbnmbqnSut
 DHy4o1uXGjA.lXZJ1sMi7f1guweD1JAq1sARbOo4MSO5tYPsi2nxgicPSoSZ
 o_XDktnRMZLw8EcgXbSSv6jI8mYG4SJ4yTnqpZPKAg5Bm9iYUNdwn7JRQNAL
 wP7VVMfyPuyipqKiFy4rWKR52WXRQi3CEK7Xi_QgJpXclzrRUVGFVxB8r5EE
 ihJqZUbs8wevcDoDASY4C1KI8J0t1vPEFWWsKKBoS6U_.q50D0CXG6YmesB7
 GhioU32s0iDMvBxj_M7KFuFShQZdifsuzTTgFoxKeRt9IePL5U4EKjDBZKUN
 emIJ1xrF_NRukB9xzq8hJkQVuxgwUXipVtVqVY1yVjIG_tQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110809211302.823888010@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Aug 2011 16:12:28 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tj@kernel.org
Cc: Metathronius Galabant <m.galabant@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: linux-kernel@vger.kernel.org
Subject: [slub p4 7/7] slub: update slabinfo tools to report per cpu partial list statistics
References: <20110809211221.831975979@linux.com>
Content-Disposition: inline; filename=update_slabinfo_cp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the slabinfo tool to report the stats on per cpu partial list usage.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 tools/slub/slabinfo.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/tools/slub/slabinfo.c
===================================================================
--- linux-2.6.orig/tools/slub/slabinfo.c	2011-08-09 14:36:34.245334733 -0500
+++ linux-2.6/tools/slub/slabinfo.c	2011-08-09 16:01:30.392982425 -0500
@@ -42,6 +42,7 @@ struct slabinfo {
 	unsigned long deactivate_remote_frees, order_fallback;
 	unsigned long cmpxchg_double_cpu_fail, cmpxchg_double_fail;
 	unsigned long alloc_node_mismatch, deactivate_bypass;
+	unsigned long cpu_partial_alloc, cpu_partial_free;
 	int numa[MAX_NODES];
 	int numa_partial[MAX_NODES];
 } slabinfo[MAX_SLABS];
@@ -455,6 +456,11 @@ static void slab_stats(struct slabinfo *
 		s->alloc_from_partial * 100 / total_alloc,
 		s->free_remove_partial * 100 / total_free);
 
+	printf("Cpu partial list     %8lu %8lu %3lu %3lu\n",
+		s->cpu_partial_alloc, s->cpu_partial_free,
+		s->cpu_partial_alloc * 100 / total_alloc,
+		s->cpu_partial_free * 100 / total_free);
+
 	printf("RemoteObj/SlabFrozen %8lu %8lu %3lu %3lu\n",
 		s->deactivate_remote_frees, s->free_frozen,
 		s->deactivate_remote_frees * 100 / total_alloc,
@@ -1209,6 +1215,8 @@ static void read_slab_dir(void)
 			slab->order_fallback = get_obj("order_fallback");
 			slab->cmpxchg_double_cpu_fail = get_obj("cmpxchg_double_cpu_fail");
 			slab->cmpxchg_double_fail = get_obj("cmpxchg_double_fail");
+			slab->cpu_partial_alloc = get_obj("cpu_partial_alloc");
+			slab->cpu_partial_free = get_obj("cpu_partial_free");
 			slab->alloc_node_mismatch = get_obj("alloc_node_mismatch");
 			slab->deactivate_bypass = get_obj("deactivate_bypass");
 			chdir("..");

