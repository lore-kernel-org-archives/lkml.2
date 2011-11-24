Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1KXQjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:39:37 -0500
Received: from mx2.parallels.com ([64.131.90.16]:46460 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab1KXQjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:39:36 -0500
Message-ID: <4ECE731E.6030508@parallels.com>
Date: Thu, 24 Nov 2011 14:38:54 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Paul Turner <pjt@google.com>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, <fweisbec@gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>   <1320182360-20043-15-git-send-email-glommer@parallels.com>   <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>   <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>   <CAKTCnzkFb2rRyOJ3Uxt13mXrB-9Ox=zgXAOZ5bZ_6Kwr64AbTA@mail.gmail.com>   <20111117085251.443fefa5.kamezawa.hiroyu@jp.fujitsu.com>   <4EC47632.2000904@parallels.com>   <CAKTCnznzpqUbMJEMwaewwjvMW1fG0J3=a8JxqKiHKNuffO7azg@mail.gmail.com>   <4EC52F32.2040708@parallels.com>   <20111121105957.9c85db16.kamezawa.hiroyu@jp.fujitsu.com>  <1322141073.2921.51.camel@twins> <4ECE6BC4.7090600@parallels.com> <1322152152.2921.64.camel@twins>
In-Reply-To: <1322152152.2921.64.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 02:29 PM, Peter Zijlstra wrote:
> On Thu, 2011-11-24 at 14:07 -0200, Glauber Costa wrote:
>> OTOH, if the use case for it includes separating processes for the cpu
>> and cpuacct cgroups in an independent manner - which apparently it does,
>> I've just learned, there isn't much we can do except try to make it cheaper.
>
> Yeah it allows that, but is that really useful? If we buy that argument
> shouldn't we split up controllers to be as minimal as possible to that
> you get as great a number of independent cgroups as possible?
>
> That way lies madness if you ask me. The two biggest controllers we
> currently have are cpu and memcg, and they aren't as orthogonal as you
> might think, see how cpusets has both a task affinity as well as node
> affinity side.
>
> The more comprehensive these controllers become, the greater also the
> overlap in functionality and thus a reduction in separation.
>
> Really, what is the killer case for separating all this nonsense? And
> no: 'Because $ustomer wants it', doesn't count.

It's hard for me to say that, since I come from a virtualization 
background: for us, a single cgroup would do just fine: even the 
division between mem and cpu is not needed. However, I've been learning 
recently that the use cases for that are quite diverse. So I'll have to 
leave the answer to Balbir, and other interested parties.

Furthermore, what I have to be implemented can be done with either one: 
I am really just bouncing around the two implementations trying to find 
a common ground... (*)

However, now that there are users for it, if this use case is really 
important, it gets harder to change it. That's more like a lesson for 
the future, for the new cgroups being proposed.

But even here, if we start adopting the policy of "cgroups must have 
zero impact for the mounted-but-not-used case, what's so wrong in having 
many small ones if their purpose differ? (more of a rethorical question)

* I wonder if the first part of the patches, that changes kstat to an 
array instead of u64 could be merged in this mean time? I have now a 
both task_group and cpuacct implementation and they both depend on it 
somehow. Peter? Paul ?
