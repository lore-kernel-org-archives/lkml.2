Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1KWPnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:43:07 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:44823 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752Ab1KWPnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:43:02 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 6/8] mm: memcg: remove unneeded checks from uncharge_page()
Date: Wed, 23 Nov 2011 16:42:29 +0100
Message-Id: <1322062951-1756-7-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <jweiner@redhat.com>

mem_cgroup_uncharge_page() is only called on either freshly allocated
pages without page->mapping or on rmapped PageAnon() pages.  There is
no need to check for a page->mapping that is not an anon_vma.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/memcontrol.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0d10be4..b9a3b94 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2989,8 +2989,6 @@ void mem_cgroup_uncharge_page(struct page *page)
 	/* early check. */
 	if (page_mapped(page))
 		return;
-	if (page->mapping && !PageAnon(page))
-		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_MAPPED);
 }
 
-- 
1.7.6.4

