Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1KOLCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:02:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43713 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab1KOLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:02:35 -0500
MIME-Version: 1.0
In-Reply-To: <4EBE4A80.6090607@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
 <1320182360-20043-15-git-send-email-glommer@parallels.com>
 <4EBD94A0.9070703@google.com> <4EBE4A80.6090607@parallels.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 15 Nov 2011 03:02:03 -0800
Message-ID: <CAPM31RLUDpaxDAw00erwgmNogbuD+=LgkJ-5i9ncJw00nvryfQ@mail.gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 12, 2011 at 2:29 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 11/11/2011 07:33 PM, Paul Turner wrote:
>>
>> On 11/01/2011 02:19 PM, Glauber Costa wrote:
>>>
>>> Now that we're providing all cpuacct capability in cpu cgroup,
>>> default CPUACCT to n. We still maintain it for compatiblity for
>>> anyone that need an independent set of tasks to be managed by it
>>> relatively to cpu cgroup, but encourage the use of cpucgroup for that.
>>>
>>> Proposing schedule of deprecation for 3.5
>>>
>>
>>
>> I'd like to see a little more separation beyond 1 linear series here.
>>
>>
>> We're doing the following things
>>
>> 1. Migrating the existing cpuacct functionality into cpu
>> 2. Deprecating cpuacct
>> 3. Adding new functionality
>>
>> I would like to consider (3) separately from 1/2 which we can and should
>> accomplish immediately due to the over-head it's currently introducing.
>> It seems less than optimal to hinge resolving that on reaching agreement
>> for the new bits.
>>
>> It also helps that the the migrated functionality in (1) is just
>> exporting state that is already being maintained by cpu so those changes
>> end up being quite small and non-invasive.
>
> So you'd like me to submit a new series, that does not do per-cgroup
> /proc/stat first?
>

Yes, I think there's a fair amount of discussion remaining on
/proc/stat and the right way to integrate it with the cpu subsystem
despite it being a not entirely natural fit.  Something I proposed at
Prague and that we could explore here is the idea of a co-mounted
controller.  In this example it would only be mountable with cpu so
you could always depend on the cpu hierarchy being there; likewise we
can put (jump-labeled) touchpoints within the cpu-subsystem to call
out for updates as appropriate when the co-mount exists.

However, this does not force us to bring all of
the required data-structures into cpu/sched and allows us to have the
config enabled with no memory cost if users choose to mount cpu and
not "cpu-proc".  This is just one proposal and there may be other ways
to do it, but I'm really not keen on stuffing it into cpu.  What do
you think?

Note: There's some clean-up to sched.c going on to pull out
data-structures and make it not a monolithic .c-#include beast.  This
will remove some of the symbol visibility requirements that would have
required you to be in cpu/sched.c before.

On the other hand, I don't think much discussion remains for cpuacct,
everyone's pretty unanimous in that they'd like to see it deprecated.
By splitting this up we can close out that quickly while we figure out the
best way to resolve the above.

Thanks!

- Paul
