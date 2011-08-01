Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1HAQ3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:29:23 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:44116 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753349Ab1HAQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:28:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Ct06DL0VM1nk3RXml3Xb_vEgMkNxQCCU34eeQODlUxTZsso
 fs5VwTxz6OT2iUWy.kHBWwncXevQ2Zr1QbEoKduf4.2NYyJsrOQVswJRrcmW
 bMPOkKCF3ede9F5NGXo4mgeVsUstytpSnLNiV6VsOkWI4AsG8FHw.Motty4n
 .gi1EnqrZR9cz1G3CyRKE2MyrELuaOpEFSpfBfHAulhNX9LdmnInGxF9jHu3
 c0Hb2pnEfEWHSfi9YwvwuHMrxsJUd2uGx_QWzrVKQx3Rc9YU9bBs.rlH_cXd
 qzr721uWFhbndXuOoCYCSD_6CFt0MTlL1kCahsFlyKgiyJSNSISDckw5Odrj
 gHgr9dDAVMR5u1.mrKm3WvWKb
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110801162852.988010328@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Aug 2011 11:28:30 -0500
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
Subject: [slub p3 7/7] slub: update slabinfo tools to report per cpu partial list statistics
References: <20110801162823.755182213@linux.com>
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
--- linux-2.6.orig/tools/slub/slabinfo.c	2011-08-01 11:03:01.275859455 -0500
+++ linux-2.6/tools/slub/slabinfo.c	2011-08-01 11:04:45.125858790 -0500
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

