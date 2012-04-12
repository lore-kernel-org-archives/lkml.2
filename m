Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2DLRGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:06:10 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43502 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943Ab2DLRGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:06:08 -0400
Message-ID: <4F870B18.5060703@parallels.com>
Date: Thu, 12 Apr 2012 14:04:24 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Cgroup in a single hierarchy (Was: Re: [RFD] Merge task counter into
 memcg)
References: <20120411185715.GA4317@somewhere.redhat.com> <4F862851.3040208@jp.fujitsu.com> <20120412113217.GB11455@somewhere.redhat.com> <4F86BFC6.2050400@parallels.com> <20120412123256.GI1787@cmpxchg.org> <4F86D4BD.1040305@parallels.com> <20120412153055.GL1787@cmpxchg.org> <20120412163825.GB13069@google.com>
In-Reply-To: <20120412163825.GB13069@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 01:38 PM, Tejun Heo wrote:
> Hello, Johannes.
>
> On Thu, Apr 12, 2012 at 05:30:55PM +0200, Johannes Weiner wrote:
>>> But also, I believe this has been widely discussed in person by
>>> people, in separate groups. Maybe Tejun can do a small writeup of
>>> where we stand?
>
> I'm still mulling over it.  What I want is single hierarchy with more
> unified rules regarding how different controllers handle the hierarchy
> in such way that different controllers may interact - ie. memcg and
> blkio can share the same page tags, or cgroup-freezer can provide
> freezing service to other controllers.  I want if a task belongs to
> cgroup, it belongs to _the_ cgroup and you can figure out all cgroup
> related stuff from there.

Agreed.
If you would allow me to side track (I'll answer the rest of the e-mail 
separately to avoid confusion)

One of the things I attempted in cpu/cpuacct, is to patch in code with 
static_branches when they are comounted. I so far temporarily failed 
because some locking order rules, and could not yet go back to that.

But we could do something more general, that could work at least until
we actually finally finish whatever rework we're doing.

1) Right now, the controllers work independently, and that code will 
have to live for at least some years anyway. So leave it there.

2) But also, insert optimization code that can be enabled/disabled when 
companion cgroups are in the same hierarchy.

3) After we mount the cgroup, apply those optimization to all of them 
from the cgroup core (the current bind stuff is just way to weird for 
that, IMHO)

4) Then we start telling userspace people to favor co-mounts as much as 
they can

5) Pray.

Of course this is a sketch, but what do you think?
