Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800Ab2INSIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:08:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759776Ab2INSIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:08:51 -0400
Date: Fri, 14 Sep 2012 14:07:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914180754.GF6221@redhat.com>
References: <20120913205827.GO7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913205827.GO7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:58:27PM -0700, Tejun Heo wrote:

[..]
> 6. Multiple hierarchies
> 
>   Apart from the apparent wheeeeeeeeness of it (I think I talked about
>   that enough the last time[1]), there's a basic problem when more
>   than one controllers interact - it's impossible to define a resource
>   group when more than two controllers are involved because the
>   intersection of different controllers is only defined in terms of
>   tasks.
> 
>   IOW, if an entity X is of interest to two controllers, there's no
>   way to map X to the cgroups of the two controllers.  X may belong to
>   A and B when viewed by one task but A' and B when viewed by another.
>   This already is a head scratcher in writeback where blkcg and memcg
>   have to interact.
> 
>   While I am pushing for unified hierarchy, I think it's necessary to
>   have different levels of granularities depending on controllers
>   given that nesting involves significant overhead and noticeable
>   controller-dependent behavior changes.
> 
>   Solution:
> 
>   I think a unified hierarchy with the ability to ignore subtrees
>   depending on controllers should work.  For example, let's assume the
>   following hierarchy.
> 
>           R
> 	/   \
>        A     B
>       / \
>      AA AB
> 
>   All controllers are co-mounted.  There is per-cgroup knob which
>   controls which controllers nest beyond it.  If blkio doesn't want to
>   distinguish AA and AB, the user can specify that blkio doesn't nest
>   beyond A and blkio would see the tree as,
> 
>           R
> 	/   \
>        A     B
> 
>   While other controllers keep seeing the original tree.  The exact
>   form of interface, I don't know yet.  It could be a single file
>   which the user echoes [-]controller name into it or per-controller
>   boolean file.
> 
>   I think this level of flexibility should be enough for most use
>   cases.  If someone disagrees, please voice your objections now.

Hi Tejun,

I am curious that why are you planning to provide capability of controller
specific view of hierarchy. To me it sounds pretty close to having
separate hierarchies per controller. Just that it is a little more
restricted configuration. 

IOW, who is is the user of this functionality and who is asking for it.
Can we go all out where all controllers have only one hierarchy view.

Thanks
Vivek
