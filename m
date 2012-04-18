Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab2DRHxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:53:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55940 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2DRHxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <4F8E646B.1020807@jp.fujitsu.com>
References: <4F862851.3040208@jp.fujitsu.com>
	<20120412113217.GB11455@somewhere.redhat.com>
	<4F86BFC6.2050400@parallels.com>
	<20120412123256.GI1787@cmpxchg.org>
	<4F86D4BD.1040305@parallels.com>
	<20120412153055.GL1787@cmpxchg.org>
	<20120412163825.GB13069@google.com>
	<20120412172309.GM1787@cmpxchg.org>
	<20120412174155.GC13069@google.com>
	<4F878480.60505@jp.fujitsu.com>
	<20120417154117.GE32402@google.com>
	<4F8D9FC4.3080800@parallels.com>
	<4F8E646B.1020807@jp.fujitsu.com>
Date: Wed, 18 Apr 2012 09:53:00 +0200
Message-ID: <CAFTL4hw3C4s6VS07pJzdBawv0ugKJJa+Vnb-Q_9FrWEq4=ka9Q@mail.gmail.com>
Subject: Re: [RFD] Merge task counter into memcg
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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

2012/4/18 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> (2012/04/18 1:52), Glauber Costa wrote:
>
>>
>>>> In short, I don't think it's better to have task-counting and fd-counting in memcg.
>>>> It's kmem, but it's more than that, I think.
>>>> Please provide subsys like ulimit.
>>>
>>> So, you think that while kmem would be enough to prevent fork-bombs,
>>> it would still make sense to limit in more traditional ways
>>> (ie. ulimit style object limits).  Hmmm....
>>>
>>
>> I personally think this is namespaces business, not cgroups.
>> If you have a process namespace, an interface that works to limit the
>> number of processes should keep working given the constraints you are
>> given.
>>
>> What doesn't make sense, is to create a *new* interface to limit
>> something that doesn't really need to be limited, just because you
>> limited a similar resource before.
>>
>
>
> Ok, limitiing forkbomb is unnecessary. ulimit+namespace should work.
> What we need is user-id namespace, isn't it ? If we have that, ulimit
> works enough fine, no overheads.

I have considered using NR_PROC rlimit on top of user namespaces to
fight forkbombs inside a container.
ie: one user namespace per container with its own rlimit.

But it doesn't work because we can have multiuser apps running in a
single container.
