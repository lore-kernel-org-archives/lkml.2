Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2AJPcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 10:32:47 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34891 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2AJPcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 10:32:45 -0500
MIME-Version: 1.0
In-Reply-To: <4F0C4BF0.9090809@linux.intel.com>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
	<1326103578.2442.50.camel@twins>
	<20120110001445.GA20542@linux-youquan.bj.intel.com>
	<1326107156.2442.59.camel@twins>
	<20120110055856.GA23741@linux-youquan.bj.intel.com>
	<1326153163.2366.7.camel@sbsiddha-mobl2>
	<20120110091805.GA28024@elte.hu>
	<4F0C4BF0.9090809@linux.intel.com>
Date: Tue, 10 Jan 2012 16:32:44 +0100
Message-ID: <CAKfTPtDCSQRbNv38sLNErhFpz=zKNUHcK1WQUeukoT4QfVtAxw@mail.gmail.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 January 2012 15:32, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 1/10/2012 1:18 AM, Ingo Molnar wrote:
>>
>> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>>
>>> On Tue, 2012-01-10 at 00:58 -0500, Youquan Song wrote:
>>>> Thanks Peter! Here is the patch.
>>>
>>> Youquan, As far as I know both the
>>> sched_smt_power_savings/sched_mc_power_savings are broken for atleast an
>>> year.
>>
>> We want a single knob, sched_power_savings - with the mc_ and
>> smt_ ones still kept and aliased to sched_power_savings, for
>> compatibility reasons.
>>
>> As Peter said, the other reasonable option is to have no knob at
>> all and restart this code from scratch.
>>
>> The other thing we should do is to add sane defaults: to turn on
>> sched_power_savings *AUTOMATICALLY* when a system is obviously
>> battery driven and turn it off when the system is obviously AC
>> driven. User-space can still implement policy and override the
>> kernel's default, but there's absolutely no excuse to not offer
>> this default ourselves.
>
> a very good default would be to keep all tasks on one package until half
> the cores in the package are busy, and then start spreading out.
>

The choice of spreading or not tasks is clearly architecture or even
platform dependent. Can't we get such optimal threshold  information
from architecture code ?

> I suspect that'll be the 90% case coverage.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
