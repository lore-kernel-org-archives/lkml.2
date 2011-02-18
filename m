Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1BRODH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:03:07 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55226 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1BRODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:03:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=thSMJPWGZt+Sh6Qw7uuQ7B3ODwnXpDB8x6zVaLCk+24+vHGWVV3GAFi59FwKv7OvWE
         rhhuRrK9xFXW5SWUD3f3u61YY3f5Yjj80LqvOaSVYCsUAlQTF/3RW4AtmRrj/dqyrRZO
         AocOXeG+IK3px9p15dJqHnJPClMIxjx8rLNRg=
Date: Fri, 18 Feb 2011 15:00:13 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 3/3 tip:x86/mm] x86-64, NUMA: Add proper function comments
 to global functions
Message-ID: <20110218140013.GI21209@htj.dyndns.org>
References: <20110218135836.GG21209@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218135836.GG21209@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/mm/numa_64.c        |   50 ++++++++++++++++++++++++++++++++++++-------
 arch/x86/mm/numa_emulation.c |   29 ++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 10 deletions(-)

Index: work/arch/x86/mm/numa_64.c
===================================================================
--- work.orig/arch/x86/mm/numa_64.c
+++ work/arch/x86/mm/numa_64.c
@@ -204,6 +204,14 @@ static int __init numa_add_memblk_to(int
 	return 0;
 }
 
+/**
+ * numa_remove_memblk_from - Remove one numa_memblk from a numa_meminfo
+ * @idx: Index of memblk to remove
+ * @mi: numa_meminfo to remove memblk from
+ *
+ * Remove @idx'th numa_memblk from @mi by shifting @mi->blk[] and
+ * decrementing @mi->nr_blks.
+ */
 void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
 {
 	mi->nr_blks--;
@@ -211,6 +219,17 @@ void __init numa_remove_memblk_from(int
 		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
 }
 
+/**
+ * numa_add_memblk - Add one numa_memblk to numa_meminfo
+ * @nid: NUMA node ID of the new memblk
+ * @start: Start address of the new memblk
+ * @end: End address of the new memblk
+ *
+ * Add a new memblk to the default numa_meminfo.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
 int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
@@ -262,6 +281,16 @@ setup_node_bootmem(int nodeid, unsigned
 	node_set_online(nodeid);
 }
 
+/**
+ * numa_cleanup_meminfo - Cleanup a numa_meminfo
+ * @mi: numa_meminfo to clean up
+ *
+ * Sanitize @mi by merging and removing unncessary memblks.  Also check for
+ * conflicts and clear unused memblks.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
 	const u64 low = 0;
@@ -352,9 +381,11 @@ static void __init numa_nodemask_from_me
 			node_set(mi->blk[i].nid, *nodemask);
 }
 
-/*
- * Reset distance table.  The current table is freed.  The next
- * numa_set_distance() call will create a new one.
+/**
+ * numa_reset_distance - Reset NUMA distance table
+ *
+ * The current table is freed.  The next numa_set_distance() call will
+ * create a new one.
  */
 void __init numa_reset_distance(void)
 {
@@ -369,10 +400,15 @@ void __init numa_reset_distance(void)
 	numa_distance = NULL;
 }
 
-/*
- * Set the distance between node @from to @to to @distance.  If distance
- * table doesn't exist, one which is large enough to accomodate all the
- * currently known nodes will be created.
+/**
+ * numa_set_distance - Set NUMA distance from one NUMA to another
+ * @from: the 'from' node to set distance
+ * @to: the 'to'  node to set distance
+ * @distance: NUMA distance
+ *
+ * Set the distance from node @from to @to to @distance.  If distance table
+ * doesn't exist, one which is large enough to accomodate all the currently
+ * known nodes will be created.
  */
 void __init numa_set_distance(int from, int to, int distance)
 {
Index: work/arch/x86/mm/numa_emulation.c
===================================================================
--- work.orig/arch/x86/mm/numa_emulation.c
+++ work/arch/x86/mm/numa_emulation.c
@@ -266,9 +266,32 @@ static int __init split_nodes_size_inter
 	return 0;
 }
 
-/*
- * Sets up the system RAM area from start_pfn to last_pfn according to the
- * numa=fake command-line option.
+/**
+ * numa_emulation - Emulate NUMA nodes
+ * @numa_meminfo: NUMA configuration to massage
+ * @numa_dist_cnt: The size of the physical NUMA distance table
+ *
+ * Emulate NUMA nodes according to the numa=fake kernel parameter.
+ * @numa_meminfo contains the physical memory configuration and is modified
+ * to reflect the emulated configuration on success.  @numa_dist_cnt is
+ * used to determine the size of the physical distance table.
+ *
+ * On success, the following modifications are made.
+ *
+ * - @numa_meminfo is updated to reflect the emulated nodes.
+ *
+ * - __apicid_to_node[] is updated such that APIC IDs are mapped to the
+ *   emulated nodes.
+ *
+ * - NUMA distance table is rebuilt to represent distances between emulated
+ *   nodes.  The distances are determined considering how emulated nodes
+ *   are mapped to physical nodes and match the actual distances.
+ *
+ * - emu_nid_to_phys[] reflects how emulated nodes are mapped to physical
+ *   nodes.  This is used by numa_add_cpu() and numa_remove_cpu().
+ *
+ * If emulation is not enabled or fails, emu_nid_to_phys[] is filled with
+ * identity mapping and no other modification is made.
  */
 void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 {
