Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768033Ab2KOPba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:31:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53808 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab2KOPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:31:29 -0500
Date: Thu, 15 Nov 2012 07:31:24 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 2/5] memcg: rework mem_cgroup_iter to use cgroup iterators
Message-ID: <20121115153124.GD7306@mtj.dyndns.org>
References: <1352820639-13521-1-git-send-email-mhocko@suse.cz>
 <1352820639-13521-3-git-send-email-mhocko@suse.cz>
 <20121113161442.GA18227@mtj.dyndns.org>
 <20121114085129.GC17111@dhcp22.suse.cz>
 <20121114185245.GF21185@mtj.dyndns.org>
 <20121115095103.GB11990@dhcp22.suse.cz>
 <20121115144732.GB7306@mtj.dyndns.org>
 <20121115151255.GE11990@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115151255.GE11990@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Nov 15, 2012 at 04:12:55PM +0100, Michal Hocko wrote:
> > Because I'd like to consider the next functions as implementation
> > detail, and having interations structred as loops tend to read better
> > and less error-prone.  e.g. when you use next functions directly, it's
> > way easier to circumvent locking requirements in a way which isn't
> > very obvious. 
> 
> The whole point behind mem_cgroup_iter is to hide all the complexity
> behind memcg iteration. Memcg code either use for_each_mem_cgroup_tree
> for !reclaim case and mem_cgroup_iter otherwise.
> 
> > So, unless it messes up the code too much (and I can't see why it
> > would), I'd much prefer if memcg used for_each_*() macros.
> 
> As I said this would mean that the current mem_cgroup_iter code would
> have to be inverted which doesn't simplify the code much. I'd rather
> hide all the grossy details inside the memcg iterator.
> Or am I still missing your suggestion?

One way or the other, I don't think the code complexity would change
much.  Again, I'd much *prefer* if memcg used what other controllers
would be using, but that's a preference and if necessary we can keep
the next functions as exposed APIs.  I think the issue I have is that
I can't see much technical justification for that.  If the code
becomes much simpler by choosing one over the other, sure, but is that
the case here?  Isn't it mostly just about where to put the same
things?  If so, what would be the rationale for requiring a different
interface?

Thanks.

-- 
tejun
