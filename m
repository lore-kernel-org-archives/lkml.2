Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0HZNYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:24:09 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33105 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751918Ab0HZNVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:25 -0400
Message-Id: <20100826132124.871870772@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:49 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 12/25] GRU - add gru hub number to context status
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_statistics
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Add the GRU hub number to the output of the GRU cch_status &
gru_status files (in /proc/sgi_uv/gru).

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/gruprocfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/misc/sgi-gru/gruprocfs.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:42.456084620 -0500
+++ linux/drivers/misc/sgi-gru/gruprocfs.c	2010-06-09 08:11:44.561086699 -0500
@@ -217,18 +217,18 @@ static int gru_seq_show(struct seq_file
 	struct gru_state *gru = GID_TO_GRU(gid);
 
 	if (gid == 0) {
-		seq_printf(file, "#%5s%5s%7s%6s%6s%8s%6s%6s\n", "gid", "nid",
+		seq_printf(file, "#%5s%5s%7s%6s%6s%8s%6s%6s\n", "hub", "gid",
 			   "ctx", "cbr", "dsr", "ctx", "cbr", "dsr");
-		seq_printf(file, "#%5s%5s%7s%6s%6s%8s%6s%6s\n", "", "", "busy",
-			   "busy", "busy", "free", "free", "free");
+		seq_printf(file, "#%5s%5s%7s%6s%6s%8s%6s%6s\n", "", "", "total",
+			   "total", "total", "free", "free", "free");
 	}
 	if (gru) {
 		ctxfree = GRU_NUM_CCH - gru->gs_active_contexts;
 		cbrfree = hweight64(gru->gs_cbr_map) * GRU_CBR_AU_SIZE;
 		dsrfree = hweight64(gru->gs_dsr_map) * GRU_DSR_AU_BYTES;
-		seq_printf(file, " %5d%5d%7ld%6ld%6ld%8ld%6ld%6ld\n",
-			   gru->gs_gid, gru->gs_blade_id, GRU_NUM_CCH - ctxfree,
-			   GRU_NUM_CBE - cbrfree, GRU_NUM_DSR_BYTES - dsrfree,
+		seq_printf(file, " %5d%5d%7d%6d%6d%8ld%6ld%6ld\n",
+			   gru->gs_blade_id, gru->gs_gid,
+			   GRU_NUM_CCH, GRU_NUM_CBE, GRU_NUM_DSR_BYTES,
 			   ctxfree, cbrfree, dsrfree);
 	}
 

