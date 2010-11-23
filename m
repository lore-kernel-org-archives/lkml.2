Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0KWXwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:52:07 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:48922 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754544Ab0KWXwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:52:02 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Fq8QPO8VM1mimf7aIl6COnm.MgcFHU1C3he42A6GSmGdJvT
 JW1EALN5ZXMWK15_vLh9Odh4L3sUb_IWgPRrImxcePLk09V4xOgkwT8k2fpE
 5zSi1HTrsFdpJ831lrzYYYOCeI9R9AKkqezYI85OG66vr1Ema4NjEVHt71a3
 STJfJRrDVpErza5kzmZI0gcS0si_ETLjWR98jYRCVDDKXmQ8bGzh5ptaHOAe
 3Y_pAfmvMRnKuv_NJXtxTDJaCaT_VI4voxYOmzm84MHn_Q.b1ilOFZoKjXfa
 3scFyAfLeP9uvpAA2WgU-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101123235159.397444837@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 23 Nov 2010 17:51:45 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [thiscpuops upgrade 06/10] vmstat: Use this_cpu_inc_return for vm statistics
References: <20101123235139.908255844@linux.com>
Content-Disposition: inline; filename=this_cpu_add_vmstat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc_return() saves us a memory access there. Code
size does not change.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/vmstat.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2010-11-23 16:35:19.000000000 -0600
+++ linux-2.6/mm/vmstat.c	2010-11-23 16:45:24.000000000 -0600
@@ -227,9 +227,7 @@ void __inc_zone_state(struct zone *zone,
 	s8 * __percpu p = pcp->vm_stat_diff + item;
 	int v, t;
 
-	__this_cpu_inc(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
 		int overstep = t / 2;
@@ -251,9 +249,7 @@ void __dec_zone_state(struct zone *zone,
 	s8 * __percpu p = pcp->vm_stat_diff + item;
 	int v, t;
 
-	__this_cpu_dec(*p);
-
-	v = __this_cpu_read(*p);
+	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
 		int overstep = t / 2;

