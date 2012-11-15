Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2KOJvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:51:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab2KOJvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:51:07 -0500
Date: Thu, 15 Nov 2012 10:51:03 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121115095103.GB11990@dhcp22.suse.cz>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
 <20121113161442.GA18227@mtj.dyndns.org>
 <20121114085129.GC17111@dhcp22.suse.cz>
 <20121114185245.GF21185@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114185245.GF21185@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-11-12 10:52:45, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Nov 14, 2012 at 09:51:29AM +0100, Michal Hocko wrote:
> > > 	reclaim(root);
> > > 	for_each_descendent_pre()
> > > 		reclaim(descendant);
> > 
> > We cannot do for_each_descendent_pre here because we do not iterate
> > through the whole hierarchy all the time. Check shrink_zone.
> 
> I'm a bit confused.  Why would that make any difference?  Shouldn't it
> be just able to test the condition and continue?

Ohh, I misunderstood your proposal. So what you are suggesting is
to put all the logic we have in mem_cgroup_iter inside what you call
reclaim here + mem_cgroup_iter_break inside the loop, right?

I do not see how this would help us much. mem_cgroup_iter is not the
nicest piece of code but it handles quite a complex requirements that we
have currently (css reference count, multiple reclaimers racing). So I
would rather keep it this way. Further simplifications are welcome of
course.

Is there any reason why you are not happy about direct using of
cgroup_next_descendant_pre?
-- 
Michal Hocko
SUSE Labs
