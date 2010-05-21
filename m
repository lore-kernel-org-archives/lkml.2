Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab0EUIsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:48:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61171 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab0EUIsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:48:53 -0400
Message-ID: <4BF64883.5090201@cn.fujitsu.com>
Date: Fri, 21 May 2010 16:46:59 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] io-controller: Document for active bytes, time and rate.
References: <4BF64712.1070500@cn.fujitsu.com>
In-Reply-To: <4BF64712.1070500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document for active bytes time and rate.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 Documentation/cgroups/blkio-controller.txt |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 48e0b21..2b015e8 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -168,6 +168,27 @@ Details of cgroup files
 	  cgroup. This is further divided by the type of operation - read or
 	  write, sync or async.
 
+- blkio.io_active_bytes
+	- Total number bytes transferred to/from the disk by the group since
+	  the group got backlogged. First two fields specify the major and
+	  minor number of the device, the third field specifies the operation
+	  type and the fourth field specifies the number of bytes. It will be
+	  reset when group gets dequeued from service tree.
+
+- blkio.io_active_time
+	- Total amount of time(in ms) spent since the group got backlogged.
+	  First two fields specify the major and minor number of the device,
+	  third field specify how long it spents since the group got
+	  backlogged. It will be reset when group gets enqueued onto service
+	  tree.
+
+- blkio.io_active_rate
+	- The io rate (in bytes/ms) of the group when group is issuing io.
+	  First two fields specify the major and minor number of the device,
+	  the third field specifies the operation type and the fourth field
+	  specifies the io rate. If there isn't any io on the group, io rate
+	  won't be computed.
+
 - blkio.avg_queue_size
 	- Debugging aid only enabled if CONFIG_DEBUG_BLK_CGROUP=y.
 	  The average queue size for this cgroup over the entire time of this
-- 1.5.4.rc3 
