Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2DQPOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:14:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2DQPN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:13:59 -0400
Date: Tue, 17 Apr 2012 08:13:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: Cgroup in a single hierarchy (Was: Re: [RFD] Merge task
 counter into memcg)
Message-ID: <20120417151352.GA32402@google.com>
References: <20120411185715.GA4317@somewhere.redhat.com>
 <4F862851.3040208@jp.fujitsu.com>
 <20120412113217.GB11455@somewhere.redhat.com>
 <4F86BFC6.2050400@parallels.com>
 <20120412123256.GI1787@cmpxchg.org>
 <4F86D4BD.1040305@parallels.com>
 <20120412153055.GL1787@cmpxchg.org>
 <20120412163825.GB13069@google.com>
 <4F870B18.5060703@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F870B18.5060703@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Apr 12, 2012 at 02:04:24PM -0300, Glauber Costa wrote:
> 1) Right now, the controllers work independently, and that code will
> have to live for at least some years anyway. So leave it there.
> 
> 2) But also, insert optimization code that can be enabled/disabled
> when companion cgroups are in the same hierarchy.
> 
> 3) After we mount the cgroup, apply those optimization to all of
> them from the cgroup core (the current bind stuff is just way to
> weird for that, IMHO)
> 
> 4) Then we start telling userspace people to favor co-mounts as much
> as they can
> 
> 5) Pray.

Pretty similar to the plan that I was thinking about.

* Provide both mechanisms from the kernel while implementing new
  features / optimizations with the assumption that there's one
  hierarchy.

* Make the switch to single hierarchy from userland, probably by
  implementing a (policy based) userland thing which takes over the
  whole cgroup hierarchy.

* Phase out multiple hierarchy support from kernel slowly.

That said, there are quite a few obstacles including being able to
support most (probably not all) use cases possible under multiple
hierarchies and managing the added complexity over the transition
period.  I don't think it's gonna be easy.  Needs more thinking.

Thanks.

-- 
tejun
