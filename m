Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1ENLRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 07:17:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53312 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab1ENLRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 07:17:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=R6URZCzNObMKi/ygprbxEPbYMP/hbZFkdSoi4W2SjLx372bcsisE/Mz/SLq21HfQxC
         PUHkeitgGbI7Uth0Q+RKDDHeeouMAStGbX7l3vilAMkMP+EcKJi4J5IQ3Cn75iMylJm0
         URYnHD/xqB8xFJqoeFXfx8kJgvV1y1YFBCUQI=
MIME-Version: 1.0
In-Reply-To: <1305306135.2466.173.camel@twins>
References: <20110428161149.GA15658@redhat.com> <20110502194416.2D61.A69D9226@jp.fujitsu.com>
 <20110502195657.2D68.A69D9226@jp.fujitsu.com> <1305129929.2914.247.camel@laptop>
 <4DCCC61F.80408@jp.fujitsu.com> <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
 <1305306135.2466.173.camel@twins>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sat, 14 May 2011 20:17:16 +0900
X-Google-Sender-Auth: EWio0_knV7EXOd7TfELmxsS6AJ8
Message-ID: <BANLkTi=u1RMS3BHBir1o2WWJcfXm0jhkQQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/14 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Fri, 2011-05-13 at 14:42 +0800, Yong Zhang wrote:
>> > - rcu_cpu_kthread_should_stop() call set_cpus_allowed_ptr() again
>> > periodically.
>> >  then, it can reset cpumask if cpuset_cpus_allowed_fallback() change it.
>> >  my debug print obseve following cpumask change occur at boot time.
>> >     1) kthread_bind: bind cpu1
>> >     2) cpuset_cpus_allowed_fallback: bind possible cpu
>> >     3) rcu_cpu_kthread_should_stop: rebind cpu1
>> > - while tsk->rt.nr_cpus_allowed == 1, sched load balancer never be crash.
>>
>> Seems rcu_spawn_one_cpu_kthread() call wake_up_process() directly,
>> which is under hotplug event CPU_UP_PREPARE. Maybe it should be
>> under CPU_ONLINE.
>
> IIRC I talked to Paul about this a while back and ONLINE is too late,
> however STARTING should work. At the time he couldn't quite get that to
> work, but the above situation is indeed the root cause of our problems.
>
> We shouldn't try to run a cpu affine thread before the cpu in question
> is actually able to run stuff.
>
> I did me a little hackery and with the below patch my kernel still
> boots...
>
> Would that sort your issue?

Great!!
Unfortunately, I can't test this until next wednesday. but I'll do it
as far as possible soon.

Thanks.
