Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2JPSZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:25:10 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:8925 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755573Ab2JPSZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:25:08 -0400
Date: Tue, 16 Oct 2012 18:25:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, devel@openvz.org,
        linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 14/14] Add documentation about the kmem controller
In-Reply-To: <1350382611-20579-15-git-send-email-glommer@parallels.com>
Message-ID: <0000013a6ad26c73-d043cf97-c44a-45c1-9cae-0a962e93a005-000000@email.amazonses.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-15-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Glauber Costa wrote:

>
> + memory.kmem.limit_in_bytes      # set/show hard limit for kernel memory
> + memory.kmem.usage_in_bytes      # show current kernel memory allocation
> + memory.kmem.failcnt             # show the number of kernel memory usage hits limits
> + memory.kmem.max_usage_in_bytes  # show max kernel memory usage recorded

Does it actually make sense to limit kernel memory? The user generally has
no idea how much kernel memory a process is using and kernel changes can
change the memory footprint. Given the fuzzy accounting in the kernel a
large cache refill (if someone configures the slab batch count to be
really big f.e.) can account a lot of memory to the wrong cgroup. The
allocation could fail.

Limiting the total memory use of a process (U+K) would make more sense I
guess. Only U is probably sufficient? In what way would a limitation on
kernel memory in use be good?

