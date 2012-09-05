Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab2IEUMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 16:12:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62641 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab2IEUMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 16:12:43 -0400
Date: Wed, 5 Sep 2012 13:12:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Message-ID: <20120905201238.GE13737@google.com>
References: <5045BD25.10301@parallels.com>
 <20120904130905.GA15683@dhcp22.suse.cz>
 <504601B8.2050907@parallels.com>
 <20120904143552.GB15683@dhcp22.suse.cz>
 <50461241.5010300@parallels.com>
 <20120904145414.GC15683@dhcp22.suse.cz>
 <50461610.30305@parallels.com>
 <20120904162501.GE15683@dhcp22.suse.cz>
 <504709D4.2010800@parallels.com>
 <20120905144942.GH5388@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905144942.GH5388@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Sep 05, 2012 at 04:49:42PM +0200, Michal Hocko wrote:
> Can we settle on the following 3 steps?
> 1) warn about "flat" hierarchies (give it X releases) - I will push it
>    to as many Suse code streams as possible (hope other distributions
>    could do the same)

I think I'm just gonna trigger WARN from cgroup core if anyone tries
to create hierarchy with a controller which doesn't support full
hierarchy.  WARN_ON_ONCE() at first and then WARN_ON() on each
creation later on.

> 2) flip the default on the root cgroup & warn when somebody tries to
>    change it to 0 (give it another X releases) that the knob will be
>    removed
> 3) remove the knob and the whole nonsese
> 4) revert 3 if somebody really objects

If we can get to 3, I don't think 4 would be a problem.

Thanks.

-- 
tejun
