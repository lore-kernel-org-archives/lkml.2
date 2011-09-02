Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1IBNgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:36:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1IBNgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:36:52 -0400
Date: Fri, 2 Sep 2011 14:36:48 +0100
From: Mel Gorman <mgorman@suse.de>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 3/3] compaction accouting fix
Message-ID: <20110902133648.GP14369@suse.de>
References: <cover.1321112552.git.minchan.kim@gmail.com>
 <282a4531f23c5e35cfddf089f93559130b4bb660.1321112552.git.minchan.kim@gmail.com>
 <20110901142027.GI14369@suse.de>
 <CAEwNFnCSgPj+KuZr0h9-0=mr29QDYnFDzvtwV5Vc1VBVtThqWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAEwNFnCSgPj+KuZr0h9-0=mr29QDYnFDzvtwV5Vc1VBVtThqWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 02:09:55PM +0900, Minchan Kim wrote:
> On Thu, Sep 1, 2011 at 11:20 PM, Mel Gorman <mgorman@suse.de> wrote:
> > On Sun, Nov 13, 2011 at 01:37:43AM +0900, Minchan Kim wrote:
> >> I saw the following accouting of compaction during test of the series.
> >
> > s/accouting/accounting/ both here and in the subject. A nicer name the
> > patch would have been
> >
> > "mm: compaction: Only update compact_blocks_moved if compaction was successful"
> 
> Thanks, I will fix it at next version. :)
> 
> >
> >>
> >> compact_blocks_moved 251
> >> compact_pages_moved 44
> >>
> >> It's very awkward to me although it's possbile because it means we try to compact 251 blocks
> >> but it just migrated 44 pages. As further investigation, I found isolate_migratepages doesn't
> >> isolate any pages but it returns ISOLATE_SUCCESS and then, it just increases compact_blocks_moved
> >> but doesn't increased compact_pages_moved.
> >>
> >> This patch makes accouting of compaction works only in case of success of isolation.
> >>
> >
> > compact_blocks_moved exists to indicate the rate compaction is
> > scanning pageblocks. If compact_blocks_moved and compact_pages_moved
> > are increasing at a similar rate for example, it could imply that
> > compaction is doing a lot of scanning but is not necessarily useful
> > work. It's not necessarily reflected by compact_fail because that
> > counter is only updated for pages that were isolated from the LRU.
> 
> You seem to say "compact_pagemigrate_failed" not "compact_fail".
> 

I did. Thanks.

> >
> > I now recognise of course that "compact_blocks_moved" was an *awful*
> > choice of name for this stat.
> 
> I hope changing stat names as follows unless it's too late(ie, it
> doesn't break ABI with any tools)
> 

I'm not aware of any tools that depend on this except my own reporting
scripts and even those do not particularly care.

> compact_blocks_moved -> compact_blocks

compact_pageblock_scanned?

> compact_pages_moved -> compact_pgmigrated_success
> compact_pagemigrate_failed -> compact_pgmigrated_fail
> compact_stall -> compact_alloc_stall
> compact_fail -> compact_alloc_fail
> compact_success -> compact_alloc_success
> 

Seems reasonable to me.

-- 
Mel Gorman
SUSE Labs
