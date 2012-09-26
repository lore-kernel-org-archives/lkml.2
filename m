Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2IZQgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:36:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38523 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755642Ab2IZQgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:36:53 -0400
Date: Wed, 26 Sep 2012 09:36:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20120926163648.GO16296@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
 <20120926140347.GD15801@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926140347.GD15801@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal, Glauber.

On Wed, Sep 26, 2012 at 04:03:47PM +0200, Michal Hocko wrote:
> Haven't we already discussed that a new memcg should inherit kmem_accounted
> from its parent for use_hierarchy?
> Say we have
> root
> |
> A (kmem_accounted = 1, use_hierachy = 1)
>  \
>   B (kmem_accounted = 0)
>    \
>     C (kmem_accounted = 1)
> 
> B find's itself in an awkward situation becuase it doesn't want to
> account u+k but it ends up doing so becuase C.

Do we really want this level of flexibility?  What's wrong with a
global switch at the root?  I'm not even sure we want this to be
optional at all.  The only reason I can think of is that it might
screw up some configurations in use which are carefully crafted to
suit userland-only usage but for that isn't what we need a transition
plan rather than another ultra flexible config option that not many
really understand the implication of?

In the same vein, do we really need both .kmem_accounted and config
option?  If someone is turning on MEMCG, just include kmem accounting.

Thanks.

-- 
tejun
