Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0DVKfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:35:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35756 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0DVKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:35:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 22 Apr 2010 19:31:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of
 PageSwapCache  pages
Message-Id: <20100422193106.9ffad4ec.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <x2l28c262361004220313q76752366l929a8959cd6d6862@mail.gmail.com>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie>
	<alpine.DEB.2.00.1004210927550.4959@router.home>
	<20100421150037.GJ30306@csn.ul.ie>
	<alpine.DEB.2.00.1004211004360.4959@router.home>
	<20100421151417.GK30306@csn.ul.ie>
	<alpine.DEB.2.00.1004211027120.4959@router.home>
	<20100421153421.GM30306@csn.ul.ie>
	<alpine.DEB.2.00.1004211038020.4959@router.home>
	<20100422092819.GR30306@csn.ul.ie>
	<20100422184621.0aaaeb5f.kamezawa.hiroyu@jp.fujitsu.com>
	<x2l28c262361004220313q76752366l929a8959cd6d6862@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 19:13:12 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Thu, Apr 22, 2010 at 6:46 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > Hmm..in my test, the case was.
> >
> > Before try_to_unmap:
> >        mapcount=1, SwapCache, remap_swapcache=1
> > After remap
> >        mapcount=0, SwapCache, rc=0.
> >
> > So, I think there may be some race in rmap_walk() and vma handling or
> > anon_vma handling. migration_entry isn't found by rmap_walk.
> >
> > Hmm..it seems this kind patch will be required for debug.
> 
> I looked do_swap_page, again.
> lock_page is called long after migration_entry_wait.
> It means lock_page can't close the race.
> 
> So I think this BUG is possible.
> What do you think?
> 

I think it's not a problem.
When migration-entry-wait is called, enry_wait() does

	pte_lock();
	check migration_pte
	check it's locked.

And after wait_on_page_locked(), it just returns to user and cause
page fault again. 

Thanks,
-Kame

