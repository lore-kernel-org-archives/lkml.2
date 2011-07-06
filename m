Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1GFS2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:28:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39246 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab1GFS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:28:16 -0400
Date: Wed, 6 Jul 2011 11:26:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Andrea Righi <andrea@betterlinux.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] Documentation: fix cgroup blkio throttle filenames
Message-Id: <20110706112626.c6e00c0c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4E14A91E.00C2:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Righi <andrea@betterlinux.com>

All the blkio.throttle.* file names are incorrectly reported without
".throttle" in the documentation. Fix it.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/cgroups/blkio-controller.txt |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- lnx-30-rc4.orig/Documentation/cgroups/blkio-controller.txt
+++ lnx-30-rc4/Documentation/cgroups/blkio-controller.txt
@@ -77,7 +77,7 @@ Throttling/Upper Limit policy
 - Specify a bandwidth rate on particular device for root group. The format
   for policy is "<major>:<minor>  <byes_per_second>".
 
-        echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.read_bps_device
+        echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device
 
   Above will put a limit of 1MB/second on reads happening for root group
   on device having major/minor number 8:16.
@@ -90,7 +90,7 @@ Throttling/Upper Limit policy
         1024+0 records out
         4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
 
- Limits for writes can be put using blkio.write_bps_device file.
+ Limits for writes can be put using blkio.throttle.write_bps_device file.
 
 Hierarchical Cgroups
 ====================
@@ -286,28 +286,28 @@ Throttling/Upper limit policy files
 	  specified in bytes per second. Rules are per deivce. Following is
 	  the format.
 
-  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.read_bps_device
+  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.read_bps_device
 
 - blkio.throttle.write_bps_device
 	- Specifies upper limit on WRITE rate to the device. IO rate is
 	  specified in bytes per second. Rules are per deivce. Following is
 	  the format.
 
-  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.write_bps_device
+  echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.write_bps_device
 
 - blkio.throttle.read_iops_device
 	- Specifies upper limit on READ rate from the device. IO rate is
 	  specified in IO per second. Rules are per deivce. Following is
 	  the format.
 
-  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.read_iops_device
+  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.read_iops_device
 
 - blkio.throttle.write_iops_device
 	- Specifies upper limit on WRITE rate to the device. IO rate is
 	  specified in io per second. Rules are per deivce. Following is
 	  the format.
 
-  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.write_iops_device
+  echo "<major>:<minor>  <rate_io_per_second>" > /cgrp/blkio.throttle.write_iops_device
 
 Note: If both BW and IOPS rules are specified for a device, then IO is
       subjectd to both the constraints.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
