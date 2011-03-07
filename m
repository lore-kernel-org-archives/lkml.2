Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1CGWxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:53:43 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab1CGWxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:53:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=p5/0MsnFp9cbHQGblfhe2eE+tDGWyP/WawSCJTm4Q4WCIu/8kTbvWW8V9OAcayaqp
	pLrexvNCeQpRXfakk37CQ==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: ctalbott@google.com, guijianfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH] blk-cgroup: Lower minimum weight from 100 to 10.
Date: Mon,  7 Mar 2011 14:53:14 -0800
Message-Id: <1299538394-9669-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've found that we still get good, useful isolation at weights this
low. I'd like to adjust the minimum so that any other changes can take
these values into account.
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

