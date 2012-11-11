Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2KKStk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:49:40 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61432 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2KKStj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <509A61B0.2040105@intel.com>
References: <1352207399-29497-1-git-send-email-alex.shi@intel.com>
	<1352207399-29497-3-git-send-email-alex.shi@intel.com>
	<CAM4v1pMLkzN5Fhmkb8brExh=OxMZ_YrvLnsZGEpG+AtBB8UDDQ@mail.gmail.com>
	<509A61B0.2040105@intel.com>
Date: Mon, 12 Nov 2012 00:19:38 +0530
Message-ID: <CAM4v1pP=iyk_ArjgB3_M1ECCjHgQJcOFOW_bzOUeFaUEdhaTuw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] sched: power aware load balance,
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, arjan@linux.intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, cl@linux.com,
        pjt@google.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex
I apologise for the delay in replying .

On Wed, Nov 7, 2012 at 6:57 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 11/07/2012 12:37 PM, Preeti Murthy wrote:
>> Hi Alex,
>>
>> What I am concerned about in this patchset as Peter also
>> mentioned in the previous discussion of your approach
>> (https://lkml.org/lkml/2012/8/13/139)
>> is that:
>>
>> 1.Using nr_running of two different sched groups to decide which one
>> can be group_leader or group_min might not be be the right approach,
>> as this might mislead us to think that a group running one task is less
>> loaded than the group running three tasks although the former task is
>> a cpu hogger.
>>
>> 2.Comparing the number of cpus with the number of tasks running in a sched
>> group to decide if the group is underloaded or overloaded again faces
>> the same issue.The tasks might be short running,not utilizing cpu much.
>
> Yes, maybe nr task is not the best indicator. But as first step, it can
> approve the proposal is a correct path and worth to try more.
> Considering the old powersaving implement is also judge on nr tasks, and
> my testing result of this. It may be still a option.
Hmm.. will think about this and get back.
>>
>> I also feel before we introduce another side to the scheduler called
>> 'power aware',why not try and see if the current scheduler itself can
>> perform better? We have an opportunity in terms of PJT's patches which
>> can help scheduler make more realistic decisions in load balance.Also
>> since PJT's metric is a statistical one,I believe we could vary it to
>> allow scheduler to do more rigorous or less rigorous power savings.
>
> will study the PJT's approach.
> Actually, current patch set is also a kind of load balance modification,
> right? :)
It is true that this is a different approach,in fact we will require
this approach
to do power savings because PJT's patches introduce a new 'metric' and not a new
'approach' in my opinion, to do smarter load balancing,not power aware
load balancing per say.So your patch is surely a step towards power
aware lb.I am just worried about the metric used in it.
>>
>> It is true however that this approach will not try and evacuate nearly idle
>> cpus over to nearly full cpus.That is definitely one of the benefits of your
>> patch,in terms of power savings,but I believe your patch is not making use
>> of the right metric to decide that.
>
> If one sched group just has one task, and another group just has one
> LCPU idle, my patch definitely will pull the task to the nearly full
> sched group. So I didn't understand what you mean 'will not try and
> evacuate nearly idle cpus over to nearly full cpus'
No, by 'this approach' I meant the current load balancer integrated with
the PJT's metric.Your approach does 'evacuate' the nearly idle cpus
over to the nearly full cpus..

Regards
Preeti U Murthy
