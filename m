Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2LMOFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44300 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2LMOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 072/241] UBIFS: introduce categorized lprops counter
Date: Thu, 13 Dec 2012 11:57:17 -0200
Message-Id: <1355407206-17100-73-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 98a1eebda3cb2a84ecf1f219bb3a95769033d1bf upstream.

This commit is a preparation for a subsequent bugfix. We introduce a
counter for categorized lprops.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ubifs/lprops.c |    6 ++++++
 fs/ubifs/ubifs.h  |    3 +++
 2 files changed, 9 insertions(+)

diff --git a/fs/ubifs/lprops.c b/fs/ubifs/lprops.c
index 86eb8e5..b33ec7a 100644
--- a/fs/ubifs/lprops.c
+++ b/fs/ubifs/lprops.c
@@ -300,8 +300,11 @@ void ubifs_add_to_cat(struct ubifs_info *c, struct ubifs_lprops *lprops,
 	default:
 		ubifs_assert(0);
 	}
+
 	lprops->flags &= ~LPROPS_CAT_MASK;
 	lprops->flags |= cat;
+	c->in_a_category_cnt += 1;
+	ubifs_assert(c->in_a_category_cnt <= c->main_lebs);
 }
 
 /**
@@ -334,6 +337,9 @@ static void ubifs_remove_from_cat(struct ubifs_info *c,
 	default:
 		ubifs_assert(0);
 	}
+
+	c->in_a_category_cnt -= 1;
+	ubifs_assert(c->in_a_category_cnt >= 0);
 }
 
 /**
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 1e5a086..51ac3e6 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1184,6 +1184,8 @@ struct ubifs_debug_info;
  * @freeable_list: list of freeable non-index LEBs (free + dirty == @leb_size)
  * @frdi_idx_list: list of freeable index LEBs (free + dirty == @leb_size)
  * @freeable_cnt: number of freeable LEBs in @freeable_list
+ * @in_a_category_cnt: count of lprops which are in a certain category, which
+ *                     basically meants that they were loaded from the flash
  *
  * @ltab_lnum: LEB number of LPT's own lprops table
  * @ltab_offs: offset of LPT's own lprops table
@@ -1413,6 +1415,7 @@ struct ubifs_info {
 	struct list_head freeable_list;
 	struct list_head frdi_idx_list;
 	int freeable_cnt;
+	int in_a_category_cnt;
 
 	int ltab_lnum;
 	int ltab_offs;
-- 
1.7.9.5

