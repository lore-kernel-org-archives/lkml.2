Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab2E3OkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:40:14 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41714 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2E3OkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:40:09 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org,
        hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 14/14] hugetlb: add HugeTLB controller documentation
Date: Wed, 30 May 2012 20:08:59 +0530
Message-Id: <1338388739-22919-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
x-cbid: 12053014-4790-0000-0000-000003025D56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Documentation/cgroups/hugetlb.txt |   45 +++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/cgroups/hugetlb.txt

diff --git a/Documentation/cgroups/hugetlb.txt b/Documentation/cgroups/hugetlb.txt
new file mode 100644
index 0000000..a9faaca
--- /dev/null
+++ b/Documentation/cgroups/hugetlb.txt
@@ -0,0 +1,45 @@
+HugeTLB Controller
+-------------------
+
+The HugeTLB controller allows to limit the HugeTLB usage per control group and
+enforces the controller limit during page fault. Since HugeTLB doesn't
+support page reclaim, enforcing the limit at page fault time implies that,
+the application will get SIGBUS signal if it tries to access HugeTLB pages
+beyond its limit. This requires the application to know beforehand how much
+HugeTLB pages it would require for its use.
+
+HugeTLB controller can be created by first mounting the cgroup filesystem.
+
+# mount -t cgroup -o hugetlb none /sys/fs/cgroup
+
+With the above step, the initial or the parent HugeTLB group becomes
+visible at /sys/fs/cgroup. At bootup, this group includes all the tasks in
+the system. /sys/fs/cgroup/tasks lists the tasks in this cgroup.
+
+New groups can be created under the parent group /sys/fs/cgroup.
+
+# cd /sys/fs/cgroup
+# mkdir g1
+# echo $$ > g1/tasks
+
+The above steps create a new group g1 and move the current shell
+process (bash) into it.
+
+Brief summary of control files
+
+ hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
+ hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
+ hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
+ hugetlb.<hugepagesize>.failcnt		   # show the number of allocation failure due to HugeTLB limit
+
+For a system supporting two hugepage size (16M and 16G) the control
+files include:
+
+hugetlb.16GB.limit_in_bytes
+hugetlb.16GB.max_usage_in_bytes
+hugetlb.16GB.usage_in_bytes
+hugetlb.16GB.failcnt
+hugetlb.16MB.limit_in_bytes
+hugetlb.16MB.max_usage_in_bytes
+hugetlb.16MB.usage_in_bytes
+hugetlb.16MB.failcnt
-- 
1.7.10

