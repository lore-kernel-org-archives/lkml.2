Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab2JPMX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:23:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab2JPMX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:23:26 -0400
Date: Tue, 16 Oct 2012 14:23:24 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 14/14] Add documentation about the kmem controller
Message-ID: <20121016122324.GG13991@dhcp22.suse.cz>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
 <1350382611-20579-15-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350382611-20579-15-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-10-12 14:16:51, Glauber Costa wrote:
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Frederic Weisbecker <fweisbec@redhat.com>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> CC: Tejun Heo <tj@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.cz

Just a nit..
> ---
>  Documentation/cgroups/memory.txt | 58 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index c07f7b4..dd15be8 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
[...]
> @@ -268,20 +273,65 @@ the amount of kernel memory used by the system. Kernel memory is fundamentally
>  different than user memory, since it can't be swapped out, which makes it
>  possible to DoS the system by consuming too much of this precious resource.
>  
> +Kernel memory won't be accounted at all until limit on a group is set. This
> +allows for existing setups to continue working without disruption.  The limit
> +cannot be set if the cgroup have children, or if there are already tasks in the
> +cgroup. When use_hierarchy == 1 and a group is accounted, its children will
> +automatically be accounted regardless of their limit value.
> +
> +After a controller is first limited, it will be kept being accounted until it

s/controller/group/

> +is removed. The memory limitation itself, can of course be removed by writing
> +-1 to memory.kmem.limit_in_bytes. In this case, kmem will be accounted, but not
> +limited.
> +

-- 
Michal Hocko
SUSE Labs
