Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1JDHsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 03:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab1JDHsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 03:48:09 -0400
Date: Tue, 4 Oct 2011 09:47:23 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Andrew Morton <akpm00@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] memcg naturalization -rc4
Message-ID: <20111004074723.GA13681@redhat.com>
References: <1317330064-28893-1-git-send-email-jweiner@redhat.com>
 <20111003161149.bc458294.akpm00@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003161149.bc458294.akpm00@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 04:11:49PM -0700, Andrew Morton wrote:
> On Thu, 29 Sep 2011 23:00:54 +0200
> Johannes Weiner <jweiner@redhat.com> wrote:
> 
> > this is the fourth revision of the memory cgroup naturalization
> > series.
> 
> The patchset removes 20 lines from include/linux/*.h and removes
> exactly zero lines from mm/*.c.  Freaky.

It adds 42 lines more comments than it deletes.

The diffstat looked better when this series included the soft limit
reclaim rework, which depends on global reclaim doing hierarchy walks.
I plan to do this next, it deletes ~500 lines.

> If we were ever brave/stupid emough to make
> CONFIG_CGROUP_MEM_RES_CTLR=y unconditional, how much could we simplify
> mm/?

There will always be a remaining part that is only of interest to
people with memory cgroups, but that doesn't mean we can't shrink this
part to an adequate size.

> We are adding bits of overhead to the  CONFIG_CGROUP_MEM_RES_CTLR=n case
> all over the place.  This patchset actually decreases the size of allnoconfig
> mm/built-in.o by 1/700th.

Most of the memcg code should be completely optimized away with =n,
except for some on-stack data structures that have a struct mem_cgroup
pointer.

In the meantime, major distros started to =y per default and people
are complaining that memcg functions show up in the profiles of their
non-memcg workload.  This one worries me more.

> A "struct mem_cgroup" sometimes gets called "mem", sometimes "memcg",
> sometimes "mem_cont".  Any more candidates?  Is there any logic to
> this?

I used memcg throughout except for two patches that I fixed up.  I
don't think there is any reason to keep them different, so I'll send a
fix to rename the remaining ones to memcg.

> Anyway...  it all looks pretty sensible to me, but the timing (at
> -rc8!) is terrible.  Please keep this material maintained for -rc1, OK?

Thanks, and yeah, the timing is ambitious, I hoped that the deferred
release and merge window could make it possible.

I'll keep it uptodate.
