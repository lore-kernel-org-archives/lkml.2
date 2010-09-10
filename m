Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0IJMNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 08:13:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0IJMNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 08:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k06pntj2teny5uJDZSpZA15waqTUZjV1JBb6aP5hjR5cLDFUzQo7KN6neybfIDNq8G
         ArbWRZhOWXKC0yTcL4mg==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=yrk-89CQqJG-2MBHnG3_HyvaCpgU7Fnb7CXqb@mail.gmail.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	<1284118900.402.35.camel@laptop>
	<AANLkTi=yrk-89CQqJG-2MBHnG3_HyvaCpgU7Fnb7CXqb@mail.gmail.com>
Date: Fri, 10 Sep 2010 14:13:28 +0200
Message-ID: <AANLkTins3MqKvrs94KYCSyMqcoo-Lr0MsfZM1Ew5VOzQ@mail.gmail.com>
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, robert.richter@amd.com,
        gorcunov@gmail.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, ming.m.lin@intel.com, yinghai@kernel.org,
        andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the broader issue here is that I think we should not have
so many subsystems hanging off of that die_register(). The NMI
should be for perf_events only. Many in there have nothing to do
with performance monitoring. They are mostly debug features.

On Fri, Sep 10, 2010 at 2:10 PM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Sep 10, 2010 at 1:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Thu, 2010-09-02 at 15:07 -0400, Don Zickus wrote:
>>> Fixes to allow unknown nmis to pass through the perf nmi handler instead
>>> of being swallowed.  Contains patches that are already in Ingo's tree.  Added
>>> here for completeness.  Based on ingo/tip
>>>
>>> Tested on intel/amd
>>>
>>> v2: patch cleanups and consolidation, no code changes
>>>
>>> Don Zickus (1):
>>>   perf, x86: Fix accidentally ack'ing a second event on intel perf
>>>     counter
>>>
>>> Peter Zijlstra (1):
>>>   perf, x86: Fix handle_irq return values
>>>
>>> Robert Richter (1):
>>>   perf, x86: Try to handle unknown nmis with an enabled PMU
>>>
>>>  arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
>>>  arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
>>>  arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
>>>  3 files changed, 56 insertions(+), 20 deletions(-)
>>
>> Both Ingo and I are getting Dazed and confused on our AMD machines, it
>> started before yesterday (that is, after backing out all my recent
>> changes it still gets dazed), so I suspect this set.
>>
>> I'll look at getting a trace of the thing, but if any of you has a
>> bright idea...
>
> I still don't buy the back-to-back NMI thing. I suspect there is
> something else going on. I have continued to track it down.
> I got closer yesterday, until I ran into other issues. It may
> have to do with throttling. I am still trying to understanding
> why the OVF_STATUS does not match the check based on
> the counter values.
>
>>
>
