Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0HZNYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:24:18 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751869Ab0HZNVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:25 -0400
Message-Id: <20100826132124.248097278@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:45 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 08/25] GRU - flush gru tlb when driver is loaded
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_init_flush_tlb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Flush the GRU TLB when the GRU driver is loaded. There may be stale
entries in the TLB if a previous GRU was unloaded since the system
was last reset.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grutlbpurge.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/misc/sgi-gru/grutlbpurge.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutlbpurge.c	2010-06-09 08:11:42.087537647 -0500
+++ linux/drivers/misc/sgi-gru/grutlbpurge.c	2010-06-09 08:11:42.891554573 -0500
@@ -380,4 +380,6 @@ void gru_tgh_flush_init(struct gru_state
 	/* first starting TGH index to use for remote purges */
 	gru->gs_tgh_first_remote = (cpus + (1 << shift) - 1) >> shift;
 
+	/* flush the GRU TLB in case there are stale entries present */
+	gru_flush_all_tlb(gru);
 }

