Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2CBUfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:35:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116Ab2CBUfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:35:41 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] memcg: fix mapcount check in move charge code for anonymous page
Date: Fri,  2 Mar 2012 15:35:08 -0500
Message-Id: <1330720508-21019-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently charge on shared anonyous pages is supposed not to moved
in task migration. To implement this, we need to check that mapcount > 1,
instread of > 2. So this patch fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git linux-next-20120228.orig/mm/memcontrol.c linux-next-20120228/mm/memcontrol.c
index b6d1bab..785f6d3 100644
--- linux-next-20120228.orig/mm/memcontrol.c
+++ linux-next-20120228/mm/memcontrol.c
@@ -5102,7 +5102,7 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 		return NULL;
 	if (PageAnon(page)) {
 		/* we don't move shared anon */
-		if (!move_anon() || page_mapcount(page) > 2)
+		if (!move_anon() || page_mapcount(page) > 1)
 			return NULL;
 	} else if (!move_file())
 		/* we ignore mapcount for file pages */
-- 
1.7.7.6

