Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1FINqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:46:31 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43101 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757650Ab1FINq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:46:28 -0400
Date: Thu, 9 Jun 2011 15:45:59 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
Message-ID: <20110609134559.GB14826@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
 <20110609131203.GB3994@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609131203.GB3994@tiehlicka.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 03:12:03PM +0200, Michal Hocko wrote:
> On Wed 01-06-11 08:25:13, Johannes Weiner wrote:
> [...]
> 
> Just a minor thing. I am really slow at reviewing these days due to
> other work that has to be done...
> 
> > +struct mem_cgroup *mem_cgroup_hierarchy_walk(struct mem_cgroup *root,
> > +					     struct mem_cgroup *prev)
> > +{
> > +	struct mem_cgroup *mem;
> 
> You want mem = NULL here because you might end up using it unitialized
> AFAICS (css_get_next returns with NULL).

Thanks for pointing it out.  It was introduced when I switched from
using @prev to continue the search to using root->last_scanned_child.

It's fixed now.
