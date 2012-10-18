Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2JRGO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:14:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab2JRGO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:14:57 -0400
Date: Thu, 18 Oct 2012 08:14:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 09/14] memcg: kmem accounting lifecycle management
Message-ID: <20121018061451.GA21277@dhcp22.suse.cz>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
 <1350382611-20579-10-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1210171624540.20813@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1210171624540.20813@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17-10-12 16:28:38, David Rientjes wrote:
> On Tue, 16 Oct 2012, Glauber Costa wrote:
[...]
> > +
> > +static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
> > +{
> > +	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted))
> > +		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_accounted);
> > +}
> 
> The set_bit() doesn't happen atomically with the test_bit(), what 
> synchronization is required for this?

The group has to be active in order to become dead so the ordering is
natural and you do not need to test&set atomicaly. Also once a group
becomes active it is always marked that way until it goes away.
-- 
Michal Hocko
SUSE Labs
