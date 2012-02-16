Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2BPQ7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:59:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64211 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BPQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:59:09 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] ceph: fix overflow check in build_snap_context()
Date: Thu, 16 Feb 2012 11:56:29 -0500
Message-Id: <1329411389-13492-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The overflow check for a + n * b should be (n > (ULONG_MAX - a) / b),
rather than (n > ULONG_MAX / b - a).

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 fs/ceph/snap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index a559c80..f04c096 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -331,7 +331,7 @@ static int build_snap_context(struct ceph_snap_realm *realm)
 
 	/* alloc new snap context */
 	err = -ENOMEM;
-	if (num > ULONG_MAX / sizeof(u64) - sizeof(*snapc))
+	if (num > (ULONG_MAX - sizeof(*snapc)) / sizeof(u64))
 		goto fail;
 	snapc = kzalloc(sizeof(*snapc) + num*sizeof(u64), GFP_NOFS);
 	if (!snapc)
-- 
1.7.5.4

