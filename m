Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0K3KPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 05:15:21 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38423 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0K3KPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 05:15:18 -0500
Subject: [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA
To: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Date: Tue, 30 Nov 2010 15:45:12 +0530
Message-ID: <20101130101506.17475.34536.stgit@localhost6.localdomain6>
In-Reply-To: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves zone_reclaim and associated helpers
outside CONFIG_NUMA. This infrastructure is reused
in the patches for page cache control that follow.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 include/linux/mmzone.h |    4 ++--
 mm/vmscan.c            |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4890662..aeede91 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -302,12 +302,12 @@ struct zone {
 	 */
 	unsigned long		lowmem_reserve[MAX_NR_ZONES];
 
-#ifdef CONFIG_NUMA
-	int node;
 	/*
 	 * zone reclaim becomes active if more unmapped pages exist.
 	 */
 	unsigned long		min_unmapped_pages;
+#ifdef CONFIG_NUMA
+	int node;
 	unsigned long		min_slab_pages;
 #endif
 	struct per_cpu_pageset __percpu *pageset;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8cc90d5..325443a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2644,7 +2644,6 @@ static int __init kswapd_init(void)
 
 module_init(kswapd_init)
 
-#ifdef CONFIG_NUMA
 /*
  * Zone reclaim mode
  *
@@ -2854,7 +2853,6 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	return ret;
 }
-#endif
 
 /*
  * page_evictable - test whether a page is evictable

