Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568Ab2CAJRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:17:21 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:33096 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965479Ab2CAJRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:17:17 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 9/9] memcg: Add memory controller documentation for hugetlb management
Date: Thu,  1 Mar 2012 14:46:20 +0530
Message-Id: <1330593380-1361-10-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12022923-7014-0000-0000-000000A9869A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Documentation/cgroups/memory.txt |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 4c95c00..f98d9af 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -43,6 +43,7 @@ Features:
  - usage threshold notifier
  - oom-killer disable knob and oom-notifier
  - Root cgroup has no limit controls.
+ - resource accounting for non reclaimable resources like HugeTLB pages
 
  Kernel memory support is work in progress, and the current version provides
  basically functionality. (See Section 2.7)
@@ -75,6 +76,12 @@ Brief summary of control files.
  memory.kmem.tcp.limit_in_bytes  # set/show hard limit for tcp buf memory
  memory.kmem.tcp.usage_in_bytes  # show current tcp buf memory allocation
 
+
+ memory.hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
+ memory.hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
+ memory.hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
+						  # see 5.7 for details
+
 1. History
 
 The memory controller has a long history. A request for comments for the memory
@@ -279,6 +286,14 @@ per cgroup, instead of globally.
 
 * tcp memory pressure: sockets memory pressure for the tcp protocol.
 
+2.8 Non reclaim resouce management
+
+This helps in enforcing limit on non reclaimable pages like HugeTLB pages.
+For non reclaim resource, enforcing limit during actual page allocation
+doesn't make sense. Hence this extension enforce limit during mmap(2).
+This enables application to fall back to alternative allocation methods
+such as allocations using normal page size when HugeTLB allocation fails.
+
 3. User Interface
 
 0. Configuration
@@ -287,6 +302,7 @@ a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_RESOURCE_COUNTERS
 c. Enable CONFIG_CGROUP_MEM_RES_CTLR
 d. Enable CONFIG_CGROUP_MEM_RES_CTLR_SWAP (to use swap extension)
+f. Enable CONFIG_MEM_RES_CTLR_NORECLAIM (to use non reclaim extension)
 
 1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 # mount -t tmpfs none /sys/fs/cgroup
@@ -510,6 +526,18 @@ unevictable=<total anon pages> N0=<node 0 pages> N1=<node 1 pages> ...
 
 And we have total = file + anon + unevictable.
 
+5.7 non reclaimable resource control files
+For a system supporting two hugepage size (16M and 16G) the control
+files include:
+
+ memory.hugetlb.16GB.limit_in_bytes
+ memory.hugetlb.16GB.max_usage_in_bytes
+ memory.hugetlb.16GB.usage_in_bytes
+ memory.hugetlb.16MB.limit_in_bytes
+ memory.hugetlb.16MB.max_usage_in_bytes
+ memory.hugetlb.16MB.usage_in_bytes
+
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.
-- 
1.7.9

