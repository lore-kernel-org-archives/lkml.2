Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2LJV40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:56:26 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:42535 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LJV4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:56:25 -0500
Message-ID: <1355176582.27758.3.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] Documentation: ABI: /sys/devices/system/node/
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>
Date: Mon, 10 Dec 2012 13:56:22 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe NUMA node sysfs files/attributes.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
Note that for the specific dates and contacts I couldn't find,
I left it as default for Oct 2002 and linux-mm.

 Documentation/ABI/stable/sysfs-devices-node | 96 ++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 49b82ca..ce259c1 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -1,7 +1,101 @@
+What:		/sys/devices/system/node/possible
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that could be possibly become online at some point.
+
+What:		/sys/devices/system/node/online
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that are online.
+
+What:		/sys/devices/system/node/has_normal_memory
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have regular memory.
+
+What:		/sys/devices/system/node/has_cpu
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have one or more CPUs.
+
+What:		/sys/devices/system/node/has_high_memory
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Nodes that have regular or high memory.
+		Depends on CONFIG_HIGHMEM.
+
 What:		/sys/devices/system/node/nodeX
 Date:		October 2002
 Contact:	Linux Memory Management list <linux-mm@kvack.org>
 Description:
 		When CONFIG_NUMA is enabled, this is a directory containing
 		information on node X such as what CPUs are local to the
-		node.
+		node. Each file is detailed next.
+
+What:		/sys/devices/system/node/nodeX/cpumap
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The node's cpumap.
+
+What:		/sys/devices/system/node/nodeX/cpulist
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The CPUs associated to the node.
+
+What:		/sys/devices/system/node/nodeX/meminfo
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Provides information about the node's distribution and memory
+		utilization. Similar to /proc/meminfo, see Documentation/filesystems/proc.txt
+
+What:		/sys/devices/system/node/nodeX/numastat
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The node's hit/miss statistics, in units of pages.
+		See Documentation/numastat.txt
+
+What:		/sys/devices/system/node/nodeX/distance
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		Distance between the node and all the other nodes
+		in the system.
+
+What:		/sys/devices/system/node/nodeX/vmstat
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		The node's zoned virtual memory statistics.
+		This is a superset of numastat.
+
+What:		/sys/devices/system/node/nodeX/compact
+Date:		February 2010
+Contact:	Mel Gorman <mel@csn.ul.ie>
+Description:
+		When this file is written to, all memory within that node
+		will be compacted. When it completes, memory will be freed
+		into blocks which have as many contiguous pages as possible
+
+What:		/sys/devices/system/node/nodeX/scan_unevictable_pages
+Date:		October 2008
+Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
+Description:
+		When set, it triggers scanning the node's unevictable lists
+		and move any pages that have become evictable onto the respective
+		zone's inactive list. See mm/vmscan.c
+
+What:		/sys/devices/system/node/nodeX/hugepages/hugepages-<size>/
+Date:		December 2009
+Contact:	Lee Schermerhorn <lee.schermerhorn@hp.com>
+Description:
+		The node's huge page size control/query attributes.
+		See Documentation/vm/hugetlbpage.txt
\ No newline at end of file
-- 
1.7.11.7



