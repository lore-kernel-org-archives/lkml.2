Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2I3Idz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:33:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43414 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2I3Idt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:33:49 -0400
Date: Sun, 30 Sep 2012 17:25:42 +0900
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
Message-ID: <20120930082542.GH10383@mtj.dyndns.org>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-7-git-send-email-glommer@parallels.com>
 <20120926155108.GE15801@dhcp22.suse.cz>
 <5064392D.5040707@parallels.com>
 <20120927134432.GE29104@dhcp22.suse.cz>
 <50658B3B.9020303@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50658B3B.9020303@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:34:19PM +0400, Glauber Costa wrote:
> On 09/27/2012 05:44 PM, Michal Hocko wrote:
> > Anyway, I have just noticed that __mem_cgroup_try_charge does
> > VM_BUG_ON(css_is_removed(&memcg->css)) on a given memcg so you should
> > keep css ref count up as well.
> 
> IIRC, css_get will prevent the cgroup directory from being removed.
> Because some allocations are expected to outlive the cgroup, we
> specifically don't want that.

That synchronous ref draining is going away.  Maybe we can do that
before kmemcg?  Michal, do you have some timeframe on mind?

Thanks.

-- 
tejun
