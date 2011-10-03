Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1JCKFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:05:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52021 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1JCKFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:05:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Oct 2011 19:04:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] memcg naturalization -rc4
Message-Id: <20111003190411.2c8c6b29.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110930093231.GE30857@redhat.com>
References: <1317330064-28893-1-git-send-email-jweiner@redhat.com>
	<20110930170510.4695b8f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20110930093231.GE30857@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 11:32:31 +0200
Johannes Weiner <jweiner@redhat.com> wrote:

> On Fri, Sep 30, 2011 at 05:05:10PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 29 Sep 2011 23:00:54 +0200
> > Thank you for your work. Now, I'm ok this series to be tested in -mm.
> > Ack. to all.
> 
> Thanks!
> 
> > Do you have any plan, concerns ?
> 
> I would really like to get them into 3.2.  While it's quite intrusive,
> I stress-tested various scenarios for quite some time - tests that
> revealed more bugs in the existing memcg code than in my changes - so
> I don't expect too big surprises.  AFAICS, Google uses these patches
> internally already and their bug reports early on also helped iron out
> the most obvious problems.
> 
> What I am concerned about is the scalability on setups with thousands
> of tiny memcgs that go into global reclaim, as this would try to scan
> pages from all existing memcgs.  There is a mitigating factor in that
> concurrent reclaimers divide the memcgs to scan among themselves (the
> shared mem_cgroup_reclaim_iter), and with hundreds or thousands of
> memcgs, I expect several threads to go into reclaim upon global memory
> pressure at the same time in the common case.  I don't have the means
> to test this and I also don't know if such setups exist or are within
> the realm of sanity that we would like to support, anyway. 

As far as I hear, some users use hundreds of memcg in a host.

> If this
> shows up, I think the fix would be as easy as bailing out early from
> the hierarchy walk, but I would like to cross that bridge when we come
> to it.
> 
> Other than that, I see no reason to hold it off.  Traditional reclaim
> without memcgs except root_mem_cgroup - what most people care about -
> is mostly unaffected.  There is a real interest in the series, and
> maintaining it out-of-tree is a major pain and quite error prone.
> 
> What do you think?
> 

I think this should be merged/tested as soon as possible because this patch
must be a base for memcg patches which are now being developped.


Thanks,
-Kame

