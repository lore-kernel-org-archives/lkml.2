Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1CHQFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:05:20 -0500
Received: from smtp-out.google.com ([74.125.121.67]:50890 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab1CHQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:05:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=HetKRArhhonjvS2oG2hfMeTXdFuZAMWE5+n/4smRYxz8x5qtvkmpEYdt82AfVR7Wq
	diOZvq3/czXGbfOn//2EA==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: ctalbott@google.com, guijianfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH][resend] blk-cgroup: Lower minimum weight from 100 to 10.
Date: Tue,  8 Mar 2011 08:04:51 -0800
Message-Id: <1299600291-30388-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've found that we still get good, useful isolation at weights this
low. I'd like to adjust the minimum so that any other changes can take
these values into account.

Signed-off-by: Justin TerAvest <teravest@google.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/cgroups/blkio-controller.txt |    2 +-
 block/blk-cgroup.h                         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 4ed7b5c..24314fd 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -140,7 +140,7 @@ Proportional weight policy files
 	- Specifies per cgroup weight. This is default weight of the group
 	  on all the devices until and unless overridden by per device rule.
 	  (See blkio.weight_device).
-	  Currently allowed range of weights is from 100 to 1000.
+	  Currently allowed range of weights is from 10 to 1000.
 
 - blkio.weight_device
 	- One can specify per cgroup per device rules using this interface.
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ea4861b..57e7234 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -240,7 +240,7 @@ static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
 
 #endif
 
-#define BLKIO_WEIGHT_MIN	100
+#define BLKIO_WEIGHT_MIN	10
 #define BLKIO_WEIGHT_MAX	1000
 #define BLKIO_WEIGHT_DEFAULT	500
 
-- 
1.7.3.1

