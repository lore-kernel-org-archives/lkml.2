Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2KQJS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 04:18:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2KQJS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 04:18:27 -0500
Message-ID: <50A7563C.4040404@oracle.com>
Date: Sat, 17 Nov 2012 17:17:48 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: axboe@kernel.dk
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation/cgroups/blkio-controller.txt: s/disk_time|disk_sectors/time|sectors/
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

For blkio controller of cgroup, both disk_time and disk_sectors were
obsolated file names.  Now we're using blkio.time and blkio.sectors to
examine how much disk time each cgroup got and how many sectors each
cgroup dispatched separately.

This patch fix the document to reflect those changes as well as a couple
of typos(secotors and io.disk_time).

Thanks,
-Jeff


Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 Documentation/cgroups/blkio-controller.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index b4b1fb3..ffa26d1 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -57,11 +57,11 @@ cgroups. Here is what you can do.
 	cat /sys/fs/cgroup/blkio/test2/tasks
 
 - At macro level, first dd should finish first. To get more precise data, keep
-  on looking at (with the help of script), at blkio.disk_time and
-  blkio.disk_sectors files of both test1 and test2 groups. This will tell how
-  much disk time (in milli seconds), each group got and how many secotors each
-  group dispatched to the disk. We provide fairness in terms of disk time, so
-  ideally io.disk_time of cgroups should be in proportion to the weight.
+  on looking at (with the help of script), at blkio.time and blkio.sectors files
+  of both test1 and test2 groups. This will tell how much disk time (in milli
+  seconds), each group got and how many sectors each group dispatched to the disk.
+  We provide fairness in terms of disk time, so ideally blkio.time of cgroups
+  should be in proportion to the weight.
 
 Throttling/Upper Limit policy
 -----------------------------
@@ -84,8 +84,8 @@ Throttling/Upper Limit policy
 
 - Run dd to read a file and see if rate is throttled to 1MB/s or not.
 
-		# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024
-		# iflag=direct
+	# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024
+	# iflag=direct
         1024+0 records in
         1024+0 records out
         4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
-- 
1.7.9.5
