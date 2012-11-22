Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2KVUb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:31:27 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32842 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756798Ab2KVUbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:31:24 -0500
Message-ID: <1353613769.10902.8.camel@joe-AO722>
Subject: [TRIVIAL PATCH] bdi_register: Add __printf verification, fix arg
 mismatch
From: Joe Perches <joe@perches.com>
To: Sage Weil <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 22 Nov 2012 11:49:29 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__printf is useful to verify format and arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ceph/super.c             |    2 +-
 include/linux/backing-dev.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 2eb43f2..e7dbb5c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -849,7 +849,7 @@ static int ceph_register_bdi(struct super_block *sb,
 		fsc->backing_dev_info.ra_pages =
 			default_backing_dev_info.ra_pages;
 
-	err = bdi_register(&fsc->backing_dev_info, NULL, "ceph-%d",
+	err = bdi_register(&fsc->backing_dev_info, NULL, "ceph-%ld",
 			   atomic_long_inc_return(&bdi_seq));
 	if (!err)
 		sb->s_bdi = &fsc->backing_dev_info;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2a9a9ab..12731a1 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -114,6 +114,7 @@ struct backing_dev_info {
 int bdi_init(struct backing_dev_info *bdi);
 void bdi_destroy(struct backing_dev_info *bdi);
 
+__printf(3, 4)
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);


