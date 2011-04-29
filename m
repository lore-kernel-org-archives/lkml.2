Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab1D2UOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:14:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23140 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1D2UOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:14:32 -0400
Message-ID: <4DBB1C16.3070307@kernel.org>
Date: Fri, 29 Apr 2011 13:14:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET tip] x86, NUMA: Unify 32 and 64bit NUMA initialization
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DBB1C19.003D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 08:28 AM, Tejun Heo wrote:
> Hello,
> 
> This patchset, finally, unifies 32 and 64bit NUMA initialization.  It
> gradually moves 64bit stuff to common code and replaces 32bit code
> with it.  Once the unification is complete, amdtopology and emulation
> are enabled for 32bit too (there's no reason not to).

got:

SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-880000000
SRAT: Node 1 PXM 1 880000000-1080000000
SRAT: Node 2 PXM 2 1080000000-1880000000
SRAT: Node 3 PXM 3 1880000000-2080000000
SRAT: Node 4 PXM 4 2080000000-2880000000
SRAT: Node 5 PXM 5 2880000000-3080000000
SRAT: Node 6 PXM 6 3080000000-3880000000
SRAT: Node 7 PXM 7 3880000000-4080000000
NUMA: Initialized distance table, cnt=8
NUMA: Node 0 [0,a0000) + [100000,80000000) -> [0,80000000)
NUMA: Node 0 [0,80000000) + [100000000,880000000) -> [0,880000000)
Adding active range (0, 0x10, 0x95) 0 entries of 3200 used
Adding active range (0, 0x100, 0x7f750) 1 entries of 3200 used
Adding active range (0, 0x100000, 0x880000) 2 entries of 3200 used
Adding active range (1, 0x880000, 0x1000000) 3 entries of 3200 used
Adding active range (2, 0x1080000, 0x1000000) 4 entries of 3200 used
------------[ cut here ]------------
WARNING: at mm/sparse.c:170 mminit_validate_memmodel_limits+0x29/0x69()
Hardware name: Sun Fire X4800 M2
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.39-rc5-tip-03938-gda7ba4e-dirty #896
Call Trace:
 [<40261c57>] warn_slowpath_common+0x65/0x7a
 [<40e30020>] ? mminit_validate_memmodel_limits+0x29/0x69
 [<40261c7b>] warn_slowpath_null+0xf/0x13
 [<40e30020>] mminit_validate_memmodel_limits+0x29/0x69
 [<40e10a2e>] add_active_range+0x34/0xdb
 [<40e0c281>] memblock_x86_register_active_regions+0x92/0xb3
 [<40e0a8c1>] numa_init+0xf1/0x5e9
 [<408cad47>] ? printk+0xf/0x11
 [<40e0af98>] x86_numa_init+0x16/0x34
 [<40e0b2dd>] initmem_init+0x8/0xbc
 [<40dfc3ce>] setup_arch+0xa27/0xad7
 [<40df85cb>] start_kernel+0x71/0x2ed
 [<40df80c4>] i386_start_kernel+0xc4/0xcb
---[ end trace 4eaa2a86a8e2da22 ]---
Adding active range (3, 0x1880000, 0x1000000) 5 entries of 3200 used
Adding active range (4, 0x2080000, 0x1000000) 6 entries of 3200 used
Adding active range (5, 0x2880000, 0x1000000) 7 entries of 3200 used
Adding active range (6, 0x3080000, 0x1000000) 8 entries of 3200 used
Adding active range (7, 0x3880000, 0x1000000) 9 entries of 3200 used
NUMA: nodes only cover 0MB of your 63478MB e820 RAM. Not used.
No NUMA configuration found
Faking a node at 0000000000000000-0000001000000000
Adding active range (0, 0x10, 0x95) 0 entries of 3200 used
Adding active range (0, 0x100, 0x7f750) 1 entries of 3200 used
Adding active range (0, 0x100000, 0x1000000) 2 entries of 3200 used
node 0 pfn: [0 - 1000000]
remap_alloc: node 0 [fffe00000-1000000000) -> [bde00000-be000000)
Initmem setup node 0 [0000000000000000-0000000fffffffff]
  NODE_DATA [#000000007de00000 - 0x0000007de02fff] (remapped)
62606MB HIGHMEM available.
2929MB LOWMEM available.
max_low_pfn = b71fe, highstart_pfn = b71fe


need following patch.

Thanks

Yinghai

[PATCH] x86, numa: Trim numa meminfo correctly

During testing 32bit numa unifying code from tj, found one system with more than 64g
fail to use numa.

It turn out we do not trim that numa meminfo correctly with max_pfn.
start could be bigger than 64g too.

Also need to make the checking in seperated loop.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/numa.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/mm/numa.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa.c
+++ linux-2.6/arch/x86/mm/numa.c
@@ -272,6 +272,7 @@ int __init numa_cleanup_meminfo(struct n
 	const u64 high = PFN_PHYS(max_pfn);
 	int i, j, k;
 
+	/* trim all entries at first */
 	for (i = 0; i < mi->nr_blks; i++) {
 		struct numa_memblk *bi = &mi->blk[i];
 
@@ -280,10 +281,12 @@ int __init numa_cleanup_meminfo(struct n
 		bi->end = min(bi->end, high);
 
 		/* and there's no empty block */
-		if (bi->start == bi->end) {
+		if (bi->start >= bi->end)
 			numa_remove_memblk_from(i--, mi);
-			continue;
-		}
+	}
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *bi = &mi->blk[i];
 
 		for (j = i + 1; j < mi->nr_blks; j++) {
 			struct numa_memblk *bj = &mi->blk[j];
@@ -313,8 +316,8 @@ int __init numa_cleanup_meminfo(struct n
 			 */
 			if (bi->nid != bj->nid)
 				continue;
-			start = max(min(bi->start, bj->start), low);
-			end = min(max(bi->end, bj->end), high);
+			start = min(bi->start, bj->start);
+			end = max(bi->end, bj->end);
 			for (k = 0; k < mi->nr_blks; k++) {
 				struct numa_memblk *bk = &mi->blk[k];
 

