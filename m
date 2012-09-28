Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab2I1Lh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:37:57 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34641 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab2I1Lhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:37:55 -0400
Message-ID: <50658B3B.9020303@parallels.com>
Date: Fri, 28 Sep 2012 15:34:19 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        Tejun Heo <tj@kernel.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-7-git-send-email-glommer@parallels.com> <20120926155108.GE15801@dhcp22.suse.cz> <5064392D.5040707@parallels.com> <20120927134432.GE29104@dhcp22.suse.cz>
In-Reply-To: <20120927134432.GE29104@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 05:44 PM, Michal Hocko wrote:
>> > the reference count aquired by mem_cgroup_get will still prevent the
>> > memcg from going away, no?
> Yes but you are outside of the rcu now and we usually do css_get before
> we rcu_unlock. mem_cgroup_get just makes sure the group doesn't get
> deallocated but it could be gone before you call it. Or I am just
> confused - these 2 levels of ref counting is really not nice.
> 
> Anyway, I have just noticed that __mem_cgroup_try_charge does
> VM_BUG_ON(css_is_removed(&memcg->css)) on a given memcg so you should
> keep css ref count up as well.
> 

IIRC, css_get will prevent the cgroup directory from being removed.
Because some allocations are expected to outlive the cgroup, we
specifically don't want that.
