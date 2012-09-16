Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2IPM0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 08:26:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51195 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2IPM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 08:26:13 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v3 2/2] Documentation: add description of dirty_background_centisecs
Date: Sun, 16 Sep 2012 08:26:04 -0400
Message-Id: <1347798364-2864-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This commit adds dirty_background_centisecs description in bdi sysfs
documentation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 Documentation/ABI/testing/sysfs-class-bdi |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/ABI/testing/sysfs-class-bdi
index 5f50097..6869736 100644
--- a/Documentation/ABI/testing/sysfs-class-bdi
+++ b/Documentation/ABI/testing/sysfs-class-bdi
@@ -48,3 +48,28 @@ max_ratio (read-write)
 	most of the write-back cache.  For example in case of an NFS
 	mount that is prone to get stuck, or a FUSE mount which cannot
 	be trusted to play fair.
+
+dirty_background_centisecs (read-write)
+
+	It is used to start early writeback of given bdi once bdi dirty
+	data exceeds product of average write bandwidth and
+	dirty_background_centisecs. It works in parallel of
+	dirty_writeback_centsecs and dirty_expire_interval based periodic
+	flushing mechanism.
+
+        It is mainly useful for tuning writeback speed at 'NFS Server'
+	sothat NFS client could see better write speed.
+	A good use case is setting it to around 100 (1 second) in the NFS
+	server for improving NFS write performance. Note that it's not
+	recommended to set it to a too small value, which might lead to
+	unnecessary flushing for small IO size.
+        Setting it to 0 disables the feature.
+
+	However, sometimes it may not match user expectations as it is based
+	on bdi write bandwidth estimation. The users should not expect this
+	threshold to work accurately.
+	Write bandwidth estimation is a best effort to estimate bdi write
+	speed bandwidth. But it can be wildly wrong in certain situations
+	such as sudden change of workload (including the workload startup
+	stage), or if there are no heavy writes since boot, in which case
+	there is no reasonable estimation yet.
-- 
1.7.9.5

