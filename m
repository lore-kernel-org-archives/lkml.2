Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761937Ab0HMRlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 13:41:47 -0400
Received: from cobra.newdream.net ([66.33.216.30]:46692 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761917Ab0HMRlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 13:41:45 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, hch@lst.de, akpm@linux-foundation.org,
        yehuda@hq.newdream.net, Sage Weil <sage@newdream.net>
Subject: [PATCH 1/8] ceph-rbd: lookup pool in osdmap by name
Date: Fri, 13 Aug 2010 10:40:33 -0700
Message-Id: <1281721240-26130-2-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1281721240-26130-1-git-send-email-sage@newdream.net>
References: <1281721240-26130-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yehuda Sadeh <yehuda@hq.newdream.net>

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/osdmap.c |   13 +++++++++++++
 fs/ceph/osdmap.h |    2 ++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/ceph/osdmap.c b/fs/ceph/osdmap.c
index e31f118..3ccd117 100644
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
1.7.0

