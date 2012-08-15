Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab2HOOXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:23:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2HOOXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:23:42 -0400
Date: Wed, 15 Aug 2012 16:23:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2 06/11] memcg: kmem controller infrastructure
Message-ID: <20120815142338.GL23985@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-7-git-send-email-glommer@parallels.com>
 <20120814172540.GD6905@dhcp22.suse.cz>
 <502B6F00.8040207@parallels.com>
 <20120815130952.GI23985@dhcp22.suse.cz>
 <502BABCF.7020608@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502BABCF.7020608@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15-08-12 18:01:51, Glauber Costa wrote:
> On 08/15/2012 05:09 PM, Michal Hocko wrote:
> > On Wed 15-08-12 13:42:24, Glauber Costa wrote:
> > [...]
> >>>> +
> >>>> +	ret = 0;
> >>>> +
> >>>> +	if (!memcg)
> >>>> +		return ret;
> >>>> +
> >>>> +	_memcg = memcg;
> >>>> +	ret = __mem_cgroup_try_charge(NULL, gfp, delta / PAGE_SIZE,
> >>>> +	    &_memcg, may_oom);
> >>>
> >>> This is really dangerous because atomic allocation which seem to be
> >>> possible could result in deadlocks because of the reclaim. 
> >>
> >> Can you elaborate on how this would happen?
> > 
> > Say you have an atomic allocation and we hit the limit so we get either
> > to reclaim which can sleep or to oom which can sleep as well (depending
> > on the oom_control).
> > 
> 
> I see now, you seem to be right.

No I am not because it seems that I am really blind these days...
We were doing this in mem_cgroup_do_charge for ages:
	if (!(gfp_mask & __GFP_WAIT))
                return CHARGE_WOULDBLOCK;

/me goes to hide and get with further feedback with a clean head.

Sorry about that.
-- 
Michal Hocko
SUSE Labs
