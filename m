Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0GGVub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:50:31 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:34446 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab0GGVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=gGnCFU5dO9B5FR1ui9speYXRKmz8nV8Rr
	yNedENSFDHl2y87vh4YLezcqKRV0pWng6xn4xzYHSPT9lF1pbyw69BaD2S6+/D60
	Ntbkh3xtOcROuUD6+MrcCpoMEwvYlT/3X+21KwUdz4i9cr5adzD6T44mLLn4Dh5t
	/abY463+MY=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       sage@newdream.net, Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH v3 01/10] ceph-rbd: lookup pool in osdmap by name
Date: Wed,  7 Jul 2010 15:11:23 -0700
Message-Id: <9e565a8e094a7a59730adcece64d1b4a12adf39f.1278539315.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
In-Reply-To: <cover.1278539315.git.yehuda@hq.newdream.net>
References: <cover.1278539315.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/osdmap.c |   13 +++++++++++++
 fs/ceph/osdmap.h |    2 ++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ceph/osdmap.c b/fs/ceph/osdmap.c
index ddc656f..11aac1c 100644
--- a/fs/ceph/osdmap.c
+++ b/fs/ceph/osdmap.c
@@ -417,6 +417,19 @@ static struct ceph_pg_pool_info *__lookup_pg_pool(struct rb_root *root, int id)
 	return NULL;
 }
 
+int ceph_pg_poolid_by_name(struct ceph_osdmap *map, const char *name)
+{
+	struct rb_node *rbp;
+
+	for (rbp = rb_first(&map->pg_pools); rbp; rbp = rb_next(rbp)) {
+		struct ceph_pg_pool_info *pi =
+			rb_entry(rbp, struct ceph_pg_pool_info, node);
+		if (pi->name && strcmp(pi->name, name) == 0)
+			return pi->id;
+	}
+	return -ENOENT;
+}
+
 static void __remove_pg_pool(struct rb_root *root, struct ceph_pg_pool_info *pi)
 {
 	rb_erase(&pi->node, root);
diff --git a/fs/ceph/osdmap.h b/fs/ceph/osdmap.h
index 970b547..a592b21 100644
--- a/fs/ceph/osdmap.h
+++ b/fs/ceph/osdmap.h
@@ -125,4 +125,6 @@ extern int ceph_calc_pg_acting(struct ceph_osdmap *osdmap, struct ceph_pg pgid,
 extern int ceph_calc_pg_primary(struct ceph_osdmap *osdmap,
 				struct ceph_pg pgid);
 
+extern int ceph_pg_poolid_by_name(struct ceph_osdmap *map, const char *name);
+
 #endif
-- 
1.5.6.5

