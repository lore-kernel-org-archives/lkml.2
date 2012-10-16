Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab2JPS44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:56:56 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:39191 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2JPS4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:56:54 -0400
Date: Tue, 16 Oct 2012 14:55:42 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Christoph Lameter <cl@linux.com>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 14/14] Add documentation about the kmem controller
Message-ID: <20121016185542.GA5423@cathedrallabs.org>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com>
 <1350382611-20579-15-git-send-email-glommer@parallels.com>
 <0000013a6ad26c73-d043cf97-c44a-45c1-9cae-0a962e93a005-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <0000013a6ad26c73-d043cf97-c44a-45c1-9cae-0a962e93a005-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 06:25:06PM +0000, Christoph Lameter wrote:
> On Tue, 16 Oct 2012, Glauber Costa wrote:
> 
> >
> > + memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
> > + memory.kmem.usage_in_bytes      # show current kernel memory allocation
> > + memory.kmem.failcnt             # show the number of kernel memory usage hits limits
> > + memory.kmem.max_usage_in_bytes  # show max kernel memory usage recorded
> 
> Does it actually make sense to limit kernel memory? The user generally has
> no idea how much kernel memory a process is using and kernel changes can
> change the memory footprint. Given the fuzzy accounting in the kernel a
> large cache refill (if someone configures the slab batch count to be
> really big f.e.) can account a lot of memory to the wrong cgroup. The
> allocation could fail.
> 
> Limiting the total memory use of a process (U+K) would make more sense I
> guess. Only U is probably sufficient? In what way would a limitation on
> kernel memory in use be good?

It's about preventing abuses caused by bugs or malicious use and avoiding
groups stepping on each others' toes. You're saying that letting a group
to allocate 32GB of paged memory is the same as 32GB of kernel memory?

I don't belive sysadmins will keep a tight limit for kernel memory but rather
a safety limit in case something goes wrong. usage_in_bytes will provide
data to get the limits better adjusted.

The innacuracy of the kmem accounting is (AFAIK) a cost tradeoff.

--
Aristeu
