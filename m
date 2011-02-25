Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab1BYO7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:59:11 -0500
Received: from relay3.sgi.com ([192.48.152.1]:47181 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754986Ab1BYO7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:59:09 -0500
Date: Fri, 25 Feb 2011 08:57:59 -0600
From: Jack Steiner <steiner@sgi.com>
To: yinghai@kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Fix calculation of size of numa_distance
Message-ID: <20110225145759.GA1606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the calculation of the size of numa_distance array. It is 2-dimemsional
array. This fixes early panics seen on large numa systems.

Signed-off-by: Jack Steiner <steiner@sgi.com>

Index: linux/arch/x86/mm/numa_64.c
===================================================================
--- linux.orig/arch/x86/mm/numa_64.c	2011-02-23 17:46:38.000000000 -0600
+++ linux/arch/x86/mm/numa_64.c	2011-02-25 08:53:45.781921592 -0600
@@ -414,7 +414,8 @@ static int __init numa_alloc_distance(vo
 
 	for_each_node_mask(i, nodes_parsed)
 		cnt = i;
-	size = ++cnt * sizeof(numa_distance[0]);
+	cnt++;
+	size = cnt * cnt * sizeof(numa_distance[0]);
 
 	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
 				      size, PAGE_SIZE);
