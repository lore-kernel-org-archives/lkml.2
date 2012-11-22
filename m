Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab2KVVuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:50:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:49632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab2KVSkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 11/38] UBIFS: introduce categorized lprops counter
Date: Wed, 21 Nov 2012 16:39:54 -0800
Message-Id: <20121122003905.473018914@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122003904.262382971@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 98a1eebda3cb2a84ecf1f219bb3a95769033d1bf upstream.

This commit is a preparation for a subsequent bugfix. We introduce a
counter for categorized lprops.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/lprops.c |    6 ++++++
 fs/ubifs/ubifs.h  |    3 +++
 2 files changed, 9 insertions(+)

--- a/fs/ubifs/lprops.c
+++ b/fs/ubifs/lprops.c
@@ -300,8 +300,11 @@ void ubifs_add_to_cat(struct ubifs_info
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
@@ -334,6 +337,9 @@ static void ubifs_remove_from_cat(struct
 	default:
 		ubifs_assert(0);
 	}
+
+	c->in_a_category_cnt -= 1;
+	ubifs_assert(c->in_a_category_cnt >= 0);
 }
 
 /**
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1187,6 +1187,8 @@ struct ubifs_debug_info;
  * @freeable_list: list of freeable non-index LEBs (free + dirty == @leb_size)
  * @frdi_idx_list: list of freeable index LEBs (free + dirty == @leb_size)
  * @freeable_cnt: number of freeable LEBs in @freeable_list
+ * @in_a_category_cnt: count of lprops which are in a certain category, which
+ *                     basically meants that they were loaded from the flash
  *
  * @ltab_lnum: LEB number of LPT's own lprops table
  * @ltab_offs: offset of LPT's own lprops table
@@ -1416,6 +1418,7 @@ struct ubifs_info {
 	struct list_head freeable_list;
 	struct list_head frdi_idx_list;
 	int freeable_cnt;
+	int in_a_category_cnt;
 
 	int ltab_lnum;
 	int ltab_offs;


