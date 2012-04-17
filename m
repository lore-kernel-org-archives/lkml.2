Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2DQPSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:18:00 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:48144 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2DQPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:17:59 -0400
Date: Tue, 17 Apr 2012 08:17:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFD] Merge task counter into memcg
Message-ID: <20120417151753.GB32402@google.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <20120412010745.GE1787@cmpxchg.org>
 <20120412145507.GC11455@somewhere.redhat.com>
 <4F87042A.2000902@parallels.com>
 <20120412165922.GA12484@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412165922.GA12484@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Thu, Apr 12, 2012 at 06:59:27PM +0200, Frederic Weisbecker wrote:
> I want:
> 
> a) to prevent the forkbomb from going far enough to DDOS the machine
> b) to be able to kill that forkbomb once detected, in one go without race
> against concurrent forks.
> 
> I think a) can work just fine with kernel stack limiting. I also need
> to be notified about the fact we reached the limit. And b) should
> be feasible with the help of the cgroup freezer. 

kmem allocation fail after reaching the limit which in turn should
fail task creation.  Isn't that the same effect as the task_counter as
implemented?

> > Is there anything for which you need to know exactly the number of
> > processes?
> 
> No that's really about prevent/kill forkbomb as far as I'm concerned.

Hmm... so, accounting overhead aside, if the only purpose is
preventing the whole machine being brought down by a fork bomb, kmem
limiting is enough, right?

Thanks.

-- 
tejun
