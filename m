Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768249Ab2KOPM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:12:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768148Ab2KOPM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:12:58 -0500
Date: Thu, 15 Nov 2012 16:12:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121115151255.GE11990@dhcp22.suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
 <20121113161442.GA18227@mtj.dyndns.org>
 <20121114085129.GC17111@dhcp22.suse.cz>
 <20121114185245.GF21185@mtj.dyndns.org>
 <20121115095103.GB11990@dhcp22.suse.cz>
 <20121115144732.GB7306@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115144732.GB7306@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-11-12 06:47:32, Tejun Heo wrote:
> Hello, Michal.
> 
> On Thu, Nov 15, 2012 at 10:51:03AM +0100, Michal Hocko wrote:
> > > I'm a bit confused.  Why would that make any difference?  Shouldn't it
> > > be just able to test the condition and continue?
> > 
> > Ohh, I misunderstood your proposal. So what you are suggesting is
> > to put all the logic we have in mem_cgroup_iter inside what you call
> > reclaim here + mem_cgroup_iter_break inside the loop, right?
> > 
> > I do not see how this would help us much. mem_cgroup_iter is not the
> > nicest piece of code but it handles quite a complex requirements that we
> > have currently (css reference count, multiple reclaimers racing). So I
> > would rather keep it this way. Further simplifications are welcome of
> > course.
> > 
> > Is there any reason why you are not happy about direct using of
> > cgroup_next_descendant_pre?
> 
> Because I'd like to consider the next functions as implementation
> detail, and having interations structred as loops tend to read better
> and less error-prone.  e.g. when you use next functions directly, it's
> way easier to circumvent locking requirements in a way which isn't
> very obvious. 

The whole point behind mem_cgroup_iter is to hide all the complexity
behind memcg iteration. Memcg code either use for_each_mem_cgroup_tree
for !reclaim case and mem_cgroup_iter otherwise.

> So, unless it messes up the code too much (and I can't see why it
> would), I'd much prefer if memcg used for_each_*() macros.

As I said this would mean that the current mem_cgroup_iter code would
have to be inverted which doesn't simplify the code much. I'd rather
hide all the grossy details inside the memcg iterator.
Or am I still missing your suggestion?
-- 
Michal Hocko
SUSE Labs
