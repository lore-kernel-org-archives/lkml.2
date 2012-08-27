Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2H0QCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:02:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45940 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab2H0QBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:01:52 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: fengguang.wu@intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 2/2] Documentation: add description of dirty_background_time
Date: Mon, 27 Aug 2012 12:01:41 -0400
Message-Id: <1346083301-3545-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This commit adds dirty_background_time description in bdi sysfs
documentation.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 Documentation/ABI/testing/sysfs-class-bdi |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/ABI/testing/sysfs-class-bdi
index 5f50097..018e26a 100644
--- a/Documentation/ABI/testing/sysfs-class-bdi
+++ b/Documentation/ABI/testing/sysfs-class-bdi
@@ -48,3 +48,16 @@ max_ratio (read-write)
 	most of the write-back cache.  For example in case of an NFS
 	mount that is prone to get stuck, or a FUSE mount which cannot
 	be trusted to play fair.
+
+dirty_background_time (read-write)
+
+	It is used to start early writeback of given bdi once bdi dirty
+	data exceeds product of average write bandwidth and
+	dirty_background_time. It is mainly useful for tuning writeback
+	speed at 'NFS Server' so that NFS client could see better write speed.
+
+	However, sometimes it may not match user expectations as it is based
+	on bdi write bandwidth estimation. Write bandwidth estimation is a
+	best effort to estimate bdi write speed bandwidth. But it can be
+	wildly wrong in certain situations.
+	dirty_background_time is expressed in msec.
-- 
1.7.9.5

