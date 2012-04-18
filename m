Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2DRIK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:10:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab2DRIKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:10:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120418065430.GB25568@somewhere>
References: <20120411185715.GA4317@somewhere.redhat.com>
	<20120412010745.GE1787@cmpxchg.org>
	<20120412145507.GC11455@somewhere.redhat.com>
	<4F87042A.2000902@parallels.com>
	<20120412165922.GA12484@somewhere.redhat.com>
	<20120417151753.GB32402@google.com>
	<20120418065430.GB25568@somewhere>
Date: Wed, 18 Apr 2012 10:10:54 +0200
Message-ID: <CAFTL4hxXT+hXWEnKop84JQ8ieHX4e=otpHnXYxdxaPgsiZYCiw@mail.gmail.com>
Subject: Re: [RFD] Merge task counter into memcg
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/18 Frederic Weisbecker <fweisbec@gmail.com>:
> On Tue, Apr 17, 2012 at 08:17:53AM -0700, Tejun Heo wrote:
>> Hello, Frederic.
>>
>> On Thu, Apr 12, 2012 at 06:59:27PM +0200, Frederic Weisbecker wrote:
>> > I want:
>> >
>> > a) to prevent the forkbomb from going far enough to DDOS the machine
>> > b) to be able to kill that forkbomb once detected, in one go without race
>> > against concurrent forks.
>> >
>> > I think a) can work just fine with kernel stack limiting. I also need
>> > to be notified about the fact we reached the limit. And b) should
>> > be feasible with the help of the cgroup freezer.
>>
>> kmem allocation fail after reaching the limit which in turn should
>> fail task creation.  Isn't that the same effect as the task_counter as
>> implemented?
>
> That's it.
>
>>
>> > > Is there anything for which you need to know exactly the number of
>> > > processes?
>> >
>> > No that's really about prevent/kill forkbomb as far as I'm concerned.
>>
>> Hmm... so, accounting overhead aside, if the only purpose is
>> preventing the whole machine being brought down by a fork bomb, kmem
>> limiting is enough, right?
>
> I think so yeah.

But this needs to be a well defined kind of kmem I think. Relying on
kernel memory
alone is too general to just protect against forkbombs. Kernel stack,
OTOH, should be
a good criteria.

But now I'm worrying, do you think this kmem.kernel_stack limitation
is going to be useful
for other kind of usecase?
