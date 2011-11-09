Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1KIFSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 00:18:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1KIFSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 00:18:14 -0500
Date: Tue, 8 Nov 2011 21:18:10 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH mm] mm: memcg: remove unused node/section info from pc->flags
 fix
In-Reply-To: <1320787408-22866-11-git-send-email-jweiner@redhat.com>
Message-ID: <alpine.LSU.2.00.1111082108160.1250@sister.anvils>
References: <1320787408-22866-1-git-send-email-jweiner@redhat.com> <1320787408-22866-11-git-send-email-jweiner@redhat.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix non-CONFIG_SPARSEMEM build, which failed with
mm/page_cgroup.c: In function `alloc_node_page_cgroup':
mm/page_cgroup.c:44: error: `start_pfn' undeclared (first use in this function)

Signed-off-by: Hugh Dickins <hughd@google.com>
---
For folding into mm-memcg-remove-unused-node-section-info-from-pc-flags.patch

 mm/page_cgroup.c |    2 --
 1 file changed, 2 deletions(-)

Hannes: heartfelt thanks to you for this great work - Hugh

--- 3.2-rc1-jw/mm/page_cgroup.c	2011-11-08 20:25:24.678395000 -0800
+++ linux/mm/page_cgroup.c	2011-11-08 20:42:05.687358464 -0800
@@ -41,9 +41,7 @@ static int __init alloc_node_page_cgroup
 	unsigned long table_size;
 	unsigned long nr_pages;
 
-	start_pfn = NODE_DATA(nid)->node_start_pfn;
 	nr_pages = NODE_DATA(nid)->node_spanned_pages;
-
 	if (!nr_pages)
 		return 0;
 
