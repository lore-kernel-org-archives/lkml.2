Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab2JKMxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:53:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756091Ab2JKMxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:53:12 -0400
Date: Thu, 11 Oct 2012 14:53:10 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>, devel@openvz.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 04/14] kmem accounting basic infrastructure
Message-ID: <20121011125309.GD29295@dhcp22.suse.cz>
References: <1349690780-15988-1-git-send-email-glommer@parallels.com>
 <1349690780-15988-5-git-send-email-glommer@parallels.com>
 <20121011101119.GB29295@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011101119.GB29295@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-10-12 12:11:19, Michal Hocko wrote:
> On Mon 08-10-12 14:06:10, Glauber Costa wrote:
[...]
> > +static void memcg_kmem_set_active(struct mem_cgroup *memcg)
> > +{
> > +	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
> > +}
> > +
> > +static bool memcg_kmem_is_accounted(struct mem_cgroup *memcg)
> > +{
> > +	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_accounted);
> > +}
> > +#endif
> 
> set_active vs. is_accounted. Is there any reason for inconsistency here?

Ahh, fixed later and 09/14 makes it memcg_kmem_is_active so this is just
a code churn. I think making it memcg_kmem_is_active here would be
better.

-- 
Michal Hocko
SUSE Labs
