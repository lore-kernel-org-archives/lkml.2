Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab0JUChW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:37:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59508 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757142Ab0JUChU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:37:20 -0400
Message-ID: <4CBFA772.7000702@cn.fujitsu.com>
Date: Thu, 21 Oct 2010 10:37:38 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
CC: Nauman Rafique <nauman@google.com>, Chad Talbott <ctalbott@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: [PATCH 4/4] blkio-cgroup: Documents for use_hierarchy interface
References: <4CBFA64D.6050800@cn.fujitsu.com>
In-Reply-To: <4CBFA64D.6050800@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documents for use_hierarchy interface.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 Documentation/cgroups/blkio-controller.txt |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index d6da611..df6c938 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -15,6 +15,21 @@ one is throttling policy which can be used to specify upper IO rate limits
 on devices. This policy is implemented in generic block layer and can be
 used on leaf nodes as well as higher level logical devices like device mapper.
 
+Currently, both hierarchical bandwidth division and flat bandwidth division are
+supported. Consider the follow hierarchy:
+
+                    grp1
+                    /  \
+                  grp2 grp3
+                  /  \
+               grp4 grp5
+
+All groups have a same weight 500, and only grp3 grp4 and grp5 are contending
+for IO bandwidth. If flat bandwidth division is in use, grp3 grp4 and grp5 will
+share the same bandwidth, that is 33.3% for each. If hierarchical bandwidth 
+division is in use, grp4 and grp5 will get 25% of bandwidth for each, gpr3
+will get the reset 50%.
+
 HOWTO
 =====
 Proportional Weight division of bandwidth
@@ -142,6 +157,12 @@ Proportional weight policy files
 	  dev     weight
 	  8:16    300
 
+- blkio.use_hierarchy
+	- If this interface is set, hierarchical bandwidth division is enabled.
+	  Ohterwise, flat bandwidth division is enabled. Currently this
+	  interface only shows up in root cgroup, and works in the case that
+	  there're no child cgroups.
+
 - blkio.time
 	- disk time allocated to cgroup per device in milliseconds. First
 	  two fields specify the major and minor number of the device and
-- 1.6.5.2 
