Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1FHPFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:05:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1FHPE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:04:57 -0400
Date: Wed, 8 Jun 2011 17:04:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] mm: make per-memcg lru lists exclusive
Message-ID: <20110608145002.GB9936@tiehlicka.suse.cz>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-9-git-send-email-hannes@cmpxchg.org>
 <BANLkTinHs7OCkpRf8=dYO0ObH5sndZ4__g@mail.gmail.com>
 <20110602142408.GB28684@cmpxchg.org>
 <BANLkTikjjH3vCiwpKrs=+vbaaACC67H7Og@mail.gmail.com>
 <20110602175702.GI28684@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602175702.GI28684@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 02-06-11 19:57:02, Johannes Weiner wrote:
> On Fri, Jun 03, 2011 at 12:54:39AM +0900, Hiroyuki Kamezawa wrote:
> > 2011/6/2 Johannes Weiner <hannes@cmpxchg.org>:
> > > On Thu, Jun 02, 2011 at 10:16:59PM +0900, Hiroyuki Kamezawa wrote:
[...]
> 
> > But it may put a page onto wrong memcgs if we do link a page to
> > another page's page->lru
> > because 2 pages may be in different cgroup each other.
> 
> Yes, I noticed that.  If it splits a huge page, it does not just add
> the tailpages to the lru head, but it links them next to the head
> page.
> 
> But I don't see how those pages could ever be in different memcgs?
> pages with page->mapping pointing to the same anon_vma are always in
> the same memcg, AFAIU.

Process can be moved to other memcg and without move_charge_at_immigrate
all previously faulted pages stay in the original group while all new
(not faulted yet) get into the new group while mapping doesn't change.
I guess this might happen with thp tailpages as well. But I do not think
this is a problem. The original group already got charged for the huge
page so we can keep all tail pages in it.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
