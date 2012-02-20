Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2BTXj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:39:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39325 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2BTXjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:39:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.239.170 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Mon, 20 Feb 2012 15:39:01 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] mm/memcg: per-memcg per-zone lru locking
In-Reply-To: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1202201538070.23274@eggly.anvils>
References: <alpine.LSU.2.00.1202201518560.23274@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flip the switch from per-zone lru locking to per-memcg per-zone lru locking.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/swap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm.orig/include/linux/swap.h	2012-02-18 11:58:09.047525220 -0800
+++ mmotm/include/linux/swap.h	2012-02-18 11:58:15.659525376 -0800
@@ -252,8 +252,8 @@ static inline void lru_cache_add_file(st
 
 static inline spinlock_t *lru_lockptr(struct lruvec *lruvec)
 {
-	/* Still use per-zone lru_lock */
-	return &lruvec->zone->lruvec.lru_lock;
+	/* Now use per-memcg-per-zone lru_lock */
+	return &lruvec->lru_lock;
 }
 
 static inline void lock_lruvec(struct lruvec *lruvec)
