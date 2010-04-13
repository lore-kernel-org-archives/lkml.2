Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0DMII3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:08:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53217 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab0DMII2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:08:28 -0400
Message-ID: <4BC42656.4080902@cn.fujitsu.com>
Date: Tue, 13 Apr 2010 16:07:50 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
CC: Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 V3] [RESEND] io-controller: Document for blkio.weight_device
References: <4BC42475.8080605@cn.fujitsu.com>
In-Reply-To: <4BC42475.8080605@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the document for blkio.weight_device

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/cgroups/blkio-controller.txt |   31 +++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index db054ea..a4ce8fe 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -76,9 +76,38 @@ CONFIG_DEBUG_BLK_CGROUP
 Details of cgroup files
 =======================
 - blkio.weight
-	- Specifies per cgroup weight.
+	- Specifies per cgroup weight. This is default weight of the group
+	  on all the devices until and unless overridden by per device rule.
+	  (See blkio.weight_device).
 	  Currently allowed range of weights is from 100 to 1000.
 
+- blkio.weight_device
+	- One can specify per cgroup per device rules using this interface.
+	  These rules override the default value of group weight as specified
+	  by blkio.weight.
+
+	  Following is the format.
+
+	  #echo dev_maj:dev_minor weight > /path/to/cgroup/blkio.weight_device
+	  Configure weight=300 on /dev/sdb (8:16) in this cgroup
+	  # echo 8:16 300 > blkio.weight_device
+	  # cat blkio.weight_device
+	  dev     weight
+	  8:16    300
+
+	  Configure weight=500 on /dev/sda (8:0) in this cgroup
+	  # echo 8:0 500 > blkio.weight_device
+	  # cat blkio.weight_device
+	  dev     weight
+	  8:0     500
+	  8:16    300
+
+	  Remove specific weight for /dev/sda in this cgroup
+	  # echo 8:0 0 > blkio.weight_device
+	  # cat blkio.weight_device
+	  dev     weight
+	  8:16    300
+
 - blkio.time
 	- disk time allocated to cgroup per device in milliseconds. First
 	  two fields specify the major and minor number of the device and
-- 
1.5.4.rc3



