Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1F3PWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:22:36 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:35756 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1F3PWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:22:35 -0400
From: Andrea Righi <andrea@betterlinux.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] blk-cgroup: fix file names in documentation
Date: Thu, 30 Jun 2011 17:22:04 +0200
Message-Id: <1309447324-3824-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the blkio.throttle.* file names are incorrectly reported without
".throttle" in the documentation. Fix it.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 Documentation/cgroups/blkio-controller.txt |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index cd45c8e..84f0a15 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
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
-- 
1.7.4.1

