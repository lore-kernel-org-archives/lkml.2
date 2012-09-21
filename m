Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab2IUW4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:56:53 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36616 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab2IUW4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:56:51 -0400
Date: Fri, 21 Sep 2012 15:56:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>, Ying Han <yinghan@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/4] mm: remove unevictable_pgs_mlockfreed
In-Reply-To: <20120921124715.GD11157@csn.ul.ie>
Message-ID: <alpine.LSU.2.00.1209211550180.23812@eggly.anvils>
References: <alpine.LSU.2.00.1209182045370.11632@eggly.anvils> <alpine.LSU.2.00.1209182055290.11632@eggly.anvils> <20120921124715.GD11157@csn.ul.ie>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply remove UNEVICTABLE_MLOCKFREED and unevictable_pgs_mlockfreed
line from /proc/vmstat: Johannes and Mel point out that it was very
unlikely to have been used by any tool, and of course we can restore
it easily enough if that turns out to be wrong.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
---
 include/linux/vm_event_item.h |    1 -
 mm/vmstat.c                   |    1 -
 2 files changed, 2 deletions(-)

--- 3.6-rc6.orig/include/linux/vm_event_item.h	2012-09-18 20:04:42.000000000 -0700
+++ 3.6-rc6/include/linux/vm_event_item.h	2012-09-21 15:13:26.608016171 -0700
@@ -52,7 +52,6 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGMUNLOCKED,
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
-		UNEVICTABLE_MLOCKFREED,	/* no longer useful: always zero */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		THP_FAULT_ALLOC,
 		THP_FAULT_FALLBACK,
--- 3.6-rc6.orig/mm/vmstat.c	2012-09-18 20:04:42.000000000 -0700
+++ 3.6-rc6/mm/vmstat.c	2012-09-21 15:13:43.724017386 -0700
@@ -781,7 +781,6 @@ const char * const vmstat_text[] = {
 	"unevictable_pgs_munlocked",
 	"unevictable_pgs_cleared",
 	"unevictable_pgs_stranded",
-	"unevictable_pgs_mlockfreed",	/* no longer useful: always zero */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	"thp_fault_alloc",
