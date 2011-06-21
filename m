Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1FUJk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 05:40:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:60714 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab1FUJk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 05:40:26 -0400
Date: Tue, 21 Jun 2011 10:40:22 +0100
From: Mel Gorman <mgorman@suse.de>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: print information when THP is disabled
 automatically
Message-ID: <20110621094022.GE9396@suse.de>
References: <1308587683-2555-1-git-send-email-amwang@redhat.com>
 <1308587683-2555-3-git-send-email-amwang@redhat.com>
 <20110620170106.GC9396@suse.de>
 <4DFF82E2.1010409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4DFF82E2.1010409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:26:58AM +0800, Cong Wang wrote:
> ??? 2011???06???21??? 01:01, Mel Gorman ??????:
> >On Tue, Jun 21, 2011 at 12:34:30AM +0800, Amerigo Wang wrote:
> >>Print information when THP is disabled automatically so that
> >>users can find this info in dmesg.
> >>
> >>Signed-off-by: WANG Cong<amwang@redhat.com>
> >>---
> >>  mm/huge_memory.c |    5 ++++-
> >>  1 files changed, 4 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>index 7fb44cc..07679da 100644
> >>--- a/mm/huge_memory.c
> >>+++ b/mm/huge_memory.c
> >>@@ -544,8 +544,11 @@ static int __init hugepage_init(void)
> >>  	 * where the extra memory used could hurt more than TLB overhead
> >>  	 * is likely to save.  The admin can still enable it through /sys.
> >>  	 */
> >>-	if (totalram_pages<  (CONFIG_TRANSPARENT_HUGEPAGE_THRESHOLD<<  (20 - PAGE_SHIFT)))
> >>+	if (totalram_pages<  (CONFIG_TRANSPARENT_HUGEPAGE_THRESHOLD
> >>+					<<  (20 - PAGE_SHIFT))) {
> >>+		printk(KERN_INFO "hugepage: disabled auotmatically\n");
> >>  		transparent_hugepage_flags = 0;
> >>+	}
> >>
> >>  	start_khugepaged();
> >>
> >
> >Guess this doesn't hurt. You misspelled automatically though and
> >mentioning "hugepage" could be confused with hugetlbfs.
> >
> 
> Yeah, sorry for the typo.
> 
> But, there are many printk messages in the same file start with "hugepage:".
> :-) I can send a patch to replace all of them with "THP" if you want...
> 

My bad. They are in a memory allocation failure path that should be
impossible to trigger but I should still have spotted the prefix at
the time and complained. Changing them to THP would be nice.

-- 
Mel Gorman
SUSE Labs
