Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1BSCQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 21:16:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48409 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752298Ab1BSCQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 21:16:10 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19kSGA1MgJkOL+y69UhcxzYwZz8yzNBGKSPd8/jNH
	yRH7ICKcclrc/N
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/zcache: Add braces for else, if 'if' had some
Date: Sat, 19 Feb 2011 03:15:55 +0100
Message-Id: <1298081755-9114-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a Coding Style issue by adding needed braces for the
else branches, if the preceding 'if' branch had braces around it.

Rationale: CodingStyle.txt Section 3
KernelVersion: linux-next 20100219

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/zcache/tmem.c   |    6 ++++--
 drivers/staging/zcache/tmem.h   |   10 ++++++----
 drivers/staging/zcache/zcache.c |    6 ++++--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/zcache/tmem.c b/drivers/staging/zcache/tmem.c
index e954d40..a4bb57f 100644
--- a/drivers/staging/zcache/tmem.c
+++ b/drivers/staging/zcache/tmem.c
@@ -352,8 +352,9 @@ insert:
 
 				objnode->slots[offset] = slot;
 				objnode->slots_in_use++;
-			} else
+			} else {
 				obj->objnode_tree_root = slot;
+			}
 		}
 		/* go down a level */
 		offset = (index >> shift) & OBJNODE_TREE_MAP_MASK;
@@ -366,8 +367,9 @@ insert:
 	if (objnode) {
 		objnode->slots_in_use++;
 		objnode->slots[offset] = pampd;
-	} else
+	} else {
 		obj->objnode_tree_root = pampd;
+	}
 	obj->pampd_count++;
 out:
 	return ret;
diff --git a/drivers/staging/zcache/tmem.h b/drivers/staging/zcache/tmem.h
index 2e07e21..6d16386 100644
--- a/drivers/staging/zcache/tmem.h
+++ b/drivers/staging/zcache/tmem.h
@@ -113,14 +113,16 @@ static inline int tmem_oid_compare(struct tmem_oid *left,
 				ret = -1;
 			else
 				return 1;
-		} else if (left->oid[1] < right->oid[1])
+		} else if (left->oid[1] < right->oid[1]) {
 			ret = -1;
-		else
+		} else {
 			ret = 1;
-	} else if (left->oid[2] < right->oid[2])
+		}
+	} else if (left->oid[2] < right->oid[2]) {
 		ret = -1;
-	else
+	} else {
 		ret = 1;
+	}
 	return ret;
 }
 
diff --git a/drivers/staging/zcache/zcache.c b/drivers/staging/zcache/zcache.c
index 61be849..c45cad6 100644
--- a/drivers/staging/zcache/zcache.c
+++ b/drivers/staging/zcache/zcache.c
@@ -340,8 +340,9 @@ found_unbuddied:
 	} else if (zh1->size != 0) { /* buddy1 in use, buddy0 is vacant */
 		ASSERT_SENTINEL(zh1, ZBH);
 		zh = zh0;
-	} else
+	} else {
 		BUG();
+	}
 	list_del_init(&zbpg->bud_list);
 	zbud_unbuddied[found_good_buddy].count--;
 	list_add_tail(&zbpg->bud_list, &zbud_buddied_list);
@@ -1191,8 +1192,9 @@ static int shrink_zcache_memory(struct shrinker *shrink, int nr, gfp_t gfp_mask)
 		if (spin_trylock(&zcache_direct_reclaim_lock)) {
 			zbud_evict_pages(nr);
 			spin_unlock(&zcache_direct_reclaim_lock);
-		} else
+		} else {
 			zcache_aborted_shrink++;
+		}
 	}
 	ret = (int)atomic_read(&zcache_zbud_curr_raw_pages);
 out:
-- 
1.7.2.2

