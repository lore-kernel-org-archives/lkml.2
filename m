Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1FCJ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:29:17 -0400
Received: from mail.perches.com ([173.55.12.10]:2457 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1FCJ3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:29:15 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 1/5] drbd: Use angle brackets for system includes
Date: Fri,  3 Jun 2011 02:28:46 -0700
Message-Id: <6d11c5760da28eacfa6acfad79037e8080a488bd.1307092588.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1307092588.git.joe@perches.com>
References: <cover.1307092588.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal include style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_nl.c   |    4 ++--
 include/linux/drbd_tag_magic.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index ef2ceed..a6ab1b2 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -928,7 +928,7 @@ struct drbd_md {
 #define NL_INT64(pn,pr,member) __u64 member;
 #define NL_BIT(pn,pr,member)   unsigned member:1;
 #define NL_STRING(pn,pr,member,len) unsigned char member[len]; int member ## _len;
-#include "linux/drbd_nl.h"
+#include <linux/drbd_nl.h>
 
 struct drbd_backing_dev {
 	struct block_device *backing_bdev;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 515bcd9..20de58d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -94,7 +94,7 @@ static int name ## _from_tags(struct drbd_conf *mdev, \
 		 arg->member ## _len = dlen; \
 		 memcpy(arg->member, tags, min_t(size_t, dlen, len)); \
 		 break;
-#include "linux/drbd_nl.h"
+#include <linux/drbd_nl.h>
 
 /* Generate the struct to tag_list functions */
 #define NL_PACKET(name, number, fields) \
@@ -129,7 +129,7 @@ name ## _to_tags(struct drbd_conf *mdev, \
 	put_unaligned(arg->member ## _len, tags++);	\
 	memcpy(tags, arg->member, arg->member ## _len); \
 	tags = (unsigned short *)((char *)tags + arg->member ## _len);
-#include "linux/drbd_nl.h"
+#include <linux/drbd_nl.h>
 
 void drbd_bcast_ev_helper(struct drbd_conf *mdev, char *helper_name);
 void drbd_nl_send_reply(struct cn_msg *, int);
diff --git a/include/linux/drbd_tag_magic.h b/include/linux/drbd_tag_magic.h
index 0695431..81f52f2 100644
--- a/include/linux/drbd_tag_magic.h
+++ b/include/linux/drbd_tag_magic.h
@@ -28,7 +28,7 @@ enum packet_types {
 #define NL_STRING(pn, pr, member, len)	\
 	unsigned char member[len]; int member ## _len; \
 	int tag_and_len ## member;
-#include "linux/drbd_nl.h"
+#include <linux/drbd_nl.h>
 
 /* declare tag-list-sizes */
 static const int tag_list_sizes[] = {
-- 
1.7.5.rc3.dirty

