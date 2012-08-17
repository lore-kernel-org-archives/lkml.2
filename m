Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2HQJAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:00:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58226 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2HQJAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <502BE41B.4020508@linux.intel.com>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
 <20120815163400.GC14534@srcf.ucam.org> <502BE41B.4020508@linux.intel.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Aug 2012 01:59:32 -0700
Message-ID: <CAPM31RJ5bLVRwVu2k_DKQD6xMCQ9iuRGhqqYrKrDeKkFFckr3g@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 11:02 AM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> On 8/15/2012 9:34 AM, Matthew Garrett wrote:
>> On Wed, Aug 15, 2012 at 01:05:38PM +0200, Peter Zijlstra wrote:
>>> On Mon, 2012-08-13 at 20:21 +0800, Alex Shi wrote:
>>>> It bases on the following assumption:
>>>> 1, If there are many task crowd in system, just let few domain cpus
>>>> running and let other cpus idle can not save power. Let all cpu take the
>>>> load, finish tasks early, and then get into idle. will save more power
>>>> and have better user experience.
>>>
>>> I'm not sure this is a valid assumption. I've had it explained to me by
>>> various people that race-to-idle isn't always the best thing. It has to
>>> do with the cost of switching power states and the duration of execution
>>> and other such things.
>>
>> This is affected by Intel's implementation - if there's a single active
>
> not just intel.. also AMD
> basically everyone who has the memory controller in the cpu package will end up with
> a restriction very similar to this.
>

I think this is circular to discussion previously held on this topic.
This preference is arch specific; we need to reduce the set of inputs
to a sensible, actionable set, and plumb that so that the architecture
and not the scheduler can supply this preference.

That you believe 100-300us is actually the tipping point vs power
migration cost is probably in itself one of the most useful replies
I've seen on this topic in all of the last few rounds of discussion
its been through.  It suggests we could actually parameterize this in
a manner similar to wake-up migration cost; with a minimum usage
average for which it's worth spilling to an idle sibling.

- Paul

> (this is because the exit-from-self-refresh latency is pretty high.. at least in DDR2/3)
>
>
