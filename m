Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2DRGyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:54:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60456 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2DRGyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:54:37 -0400
Date: Wed, 18 Apr 2012 08:54:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
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
Message-ID: <20120418065430.GB25568@somewhere>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <20120412010745.GE1787@cmpxchg.org>
 <20120412145507.GC11455@somewhere.redhat.com>
 <4F87042A.2000902@parallels.com>
 <20120412165922.GA12484@somewhere.redhat.com>
 <20120417151753.GB32402@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417151753.GB32402@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 08:17:53AM -0700, Tejun Heo wrote:
> Hello, Frederic.
> 
> On Thu, Apr 12, 2012 at 06:59:27PM +0200, Frederic Weisbecker wrote:
> > I want:
> > 
> > a) to prevent the forkbomb from going far enough to DDOS the machine
> > b) to be able to kill that forkbomb once detected, in one go without race
> > against concurrent forks.
> > 
> > I think a) can work just fine with kernel stack limiting. I also need
> > to be notified about the fact we reached the limit. And b) should
> > be feasible with the help of the cgroup freezer. 
> 
> kmem allocation fail after reaching the limit which in turn should
> fail task creation.  Isn't that the same effect as the task_counter as
> implemented?

That's it.

> 
> > > Is there anything for which you need to know exactly the number of
> > > processes?
> > 
> > No that's really about prevent/kill forkbomb as far as I'm concerned.
> 
> Hmm... so, accounting overhead aside, if the only purpose is
> preventing the whole machine being brought down by a fork bomb, kmem
> limiting is enough, right?

I think so yeah.
