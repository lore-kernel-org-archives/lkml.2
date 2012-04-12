Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2DLQ7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:59:36 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47009 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2DLQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:59:34 -0400
Date: Thu, 12 Apr 2012 18:59:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120412165922.GA12484@somewhere.redhat.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <20120412010745.GE1787@cmpxchg.org>
 <20120412145507.GC11455@somewhere.redhat.com>
 <4F87042A.2000902@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F87042A.2000902@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 01:34:50PM -0300, Glauber Costa wrote:
> On 04/12/2012 11:55 AM, Frederic Weisbecker wrote:
> >I don't know how the kernel stack is allocated for tasks. Do you mean
> >that we allocate a chunck of it for each new task and we could rely
> >on that?
> >
> More than this: amount of kernel stack is really, really something
> indirect if what you want to track is # of processes. Now, Hannes
> made a fair point in his other e-mail about what is a resource and
> what is not.

I start to consider this option, are there other people interested
in accounting/limiting kernel stack as well?

> 
> >>>  After all, we would only restrict the number of tasks for the
> >>>  resources they require
> >It depends if the kernel stack can have other kind of "consumer".
> >
> It also depends on what you really want to achieve.
> If you want to prevent fork bombs, limiting kernel stack will do just fine.

I want:

a) to prevent the forkbomb from going far enough to DDOS the machine
b) to be able to kill that forkbomb once detected, in one go without race
against concurrent forks.

I think a) can work just fine with kernel stack limiting. I also need
to be notified about the fact we reached the limit. And b) should
be feasible with the help of the cgroup freezer. 

> 
> Is there anything for which you need to know exactly the number of
> processes?

No that's really about prevent/kill forkbomb as far as I'm concerned.
