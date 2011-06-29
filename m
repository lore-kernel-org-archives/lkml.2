Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab1F2Cas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 22:30:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1F2Cal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 22:30:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=av3nrx4S7Xjo4bf2k7TKekNEGy8QOgZ2aXUYlp8PL670v8OcC6TghmXsguDNBy49H
	+REnv8ricYWsdxjnznFHQ==
MIME-Version: 1.0
In-Reply-To: <BANLkTi=KvKZtjFuDNxfKKAxysWUw4CiJecG8wnckYPvv9BzNrA@mail.gmail.com>
References: <1308797024.23204.95.camel@debian> <1308819748.1022.69.camel@twins>
 <1308876099.23204.124.camel@debian> <1309219329.14604.11.camel@debian>
 <1309273180.6701.213.camel@twins> <BANLkTi=KvKZtjFuDNxfKKAxysWUw4CiJecG8wnckYPvv9BzNrA@mail.gmail.com>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 28 Jun 2011 19:30:19 -0700
Message-ID: <CAOM-RdPBc2kcWDtUvTDe9PqQMq=u5qcEprDbC9guVi+wX+9bRg@mail.gmail.com>
Subject: Re: power increase issue on light load
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Alex, Shi" <alex.shi@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        len.brown@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 10:13 AM, Nikhil Rao <ncrao@google.com> wrote:
> On Tue, Jun 28, 2011 at 7:59 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2011-06-28 at 08:02 +0800, Alex,Shi wrote:
>>> > >
>>> > > What happens if you try something like the below. Increased imbalance
>>> > > might lead to more load-balance action, which might lead to more task
>>> > > migration/waking up of cpus etc.
>>> > >
>>> > > If the below makes any difference, Nikhil's changes have a funny that
>>> > > needs to be caught.
>>> >
>>> > Yes, it most remove the commit effect, So the power recovered.
>>> >
>>> > In fact the only suspicious I found is large imbalance, but that is
>>> > the commit want ...
>>>
>>> Any further comments for this?
>>
>> I had a look over all that stuff, but I couldn't find an obvious unit
>> mis-match in any of the imbalance code. Nikhil any clue?
>>
>
> Sorry for the late reply. My mailbox filters failed me :-(
>
> Alex -- I'm looking into this issue. Will get back to you soon.
>

Looking at the schedstat data Alex posted:
- Distribution of load balances across cores looks about the same.
- Load balancer does more idle balances on 3.0-rc4 as compared to
2.6.39 on SMT and NUMA domains. Busy and newidle balances are a mixed
bag.
- I see far fewer affine wakeups on 3.0-rc4 as compared to 2.6.39.
About half as many affine wakeups on SMT and about a quarter as many
on NUMA.

I'm investigating the impact of the load resolution patchset on
effective load and wake affine calculations. This seems to be the most
obvious difference from the schedstat data.

Alex -- I have a couple of questions about your test setup and results.
- What is the impact on throughput of these benchmarks?
- Would it be possible to get a "perf sched" trace on these two kernels?
- I'm assuming the three sched domains are SMT, MC and NUMA. Is that
right? Do you have any powersavings balance or special sched domain
flags enabled?
- Are you using group scheduling? If so, what does your setup look like?

-Thanks,
Nikhil
