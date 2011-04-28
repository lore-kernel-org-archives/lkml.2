Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab1D1Iyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:54:44 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:36073 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1D1Iym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:54:42 -0400
Date: Thu, 28 Apr 2011 10:54:32 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 3/8] vmscan: make isolate_lru_page with filter aware
Message-ID: <20110428085432.GI12437@cmpxchg.org>
References: <cover.1303833415.git.minchan.kim@gmail.com>
 <232562452317897b5acb1445803410d74233a923.1303833417.git.minchan.kim@gmail.com>
 <20110427170304.d31c1398.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110427170304.d31c1398.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 05:03:04PM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed, 27 Apr 2011 01:25:20 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > In some __zone_reclaim case, we don't want to shrink mapped page.
> > Nonetheless, we have isolated mapped page and re-add it into
> > LRU's head. It's unnecessary CPU overhead and makes LRU churning.
> > 
> > Of course, when we isolate the page, the page might be mapped but
> > when we try to migrate the page, the page would be not mapped.
> > So it could be migrated. But race is rare and although it happens,
> > it's no big deal.
> > 
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> 
> 
> Hmm, it seems mm/memcontrol.c::mem_cgroup_isolate_pages() should be updated, too.

memcg reclaim always does sc->may_unmap = 1.  What is there to
communicate to mem_cgroup_isolate_pages?
