Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1FIJXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:23:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47413
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752117Ab1FIJXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:23:36 -0400
Date: Thu, 9 Jun 2011 05:23:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] mm: make per-memcg lru lists exclusive
Message-ID: <20110609092310.GA10741@infradead.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-9-git-send-email-hannes@cmpxchg.org>
 <20110607124213.GB18571@infradead.org>
 <20110608085400.GA17886@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608085400.GA17886@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 10:54:00AM +0200, Johannes Weiner wrote:
> > Wouldn't it be simpler if we always have a stub mem_cgroup_per_zone
> > structure even for non-memcg kernels, and always operate on a
> > single instance per node of those for non-memcg kernels?  In effect the
> > lruvec almost is something like that, just adding another layer of
> > abstraction.
> 
> I assume you meant 'single instance per zone'; the lruvec is this.

Yes, sorry.

> It
> exists per zone and per mem_cgroup_per_zone so there is no difference
> between memcg kernels and non-memcg ones in generic code.  But maybe
> you really meant 'node' and I just don't get it?  Care to elaborate a
> bit more?

My suggestion was to not bother with adding the new lruvec concept,
but make sure we always have sturct mem_cgroup_per_zone around even
for non-memcg kernel, thus making the code even more similar for
using cgroups or not, and avoiding to keep the superflous lruvec
in the zone around for the cgroup case.  Basically always keeping
a minimal stub memcg infrastructure around.

This is really just from the top of my head, so it might not actually
be feasily, but it's similar to how we do things elsewhere in the
kernel.

