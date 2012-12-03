Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2LCOfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:35:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43531 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab2LCOfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:43 -0500
Message-Id: <20121203143146.764748762@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:31:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 01/89] UBIFS: introduce categorized lprops counter
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 98a1eebda3cb2a84ecf1f219bb3a95769033d1bf upstream.

This commit is a preparation for a subsequent bugfix. We introduce a
counter for categorized lprops.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/lprops.c |    6 ++++++
 fs/ubifs/ubifs.h  |    3 +++
 2 files changed, 9 insertions(+)

diff --git a/fs/ubifs/lprops.c b/fs/ubifs/lprops.c
index e5a2a35..46190a7 100644
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
index 5486346..d133c27 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1183,6 +1183,8 @@ struct ubifs_debug_info;
  * @freeable_list: list of freeable non-index LEBs (free + dirty == @leb_size)
  * @frdi_idx_list: list of freeable index LEBs (free + dirty == @leb_size)
  * @freeable_cnt: number of freeable LEBs in @freeable_list
+ * @in_a_category_cnt: count of lprops which are in a certain category, which
+ *                     basically meants that they were loaded from the flash
  *
  * @ltab_lnum: LEB number of LPT's own lprops table
  * @ltab_offs: offset of LPT's own lprops table
@@ -1412,6 +1414,7 @@ struct ubifs_info {
 	struct list_head freeable_list;
 	struct list_head frdi_idx_list;
 	int freeable_cnt;
+	int in_a_category_cnt;
 
 	int ltab_lnum;
 	int ltab_offs;


