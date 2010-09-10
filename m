Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0IJMKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 08:10:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0IJMKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 08:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xmIDbcwaZIqo5fcKq8KwB3wB/LaPa73p+IwT4F8qelHIUdmjwXvsQOnBgZR+rzA2XC
         VY7y7Hajv2UI4bIYq9pQ==
MIME-Version: 1.0
In-Reply-To: <1284118900.402.35.camel@laptop>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	<1284118900.402.35.camel@laptop>
Date: Fri, 10 Sep 2010 14:10:03 +0200
Message-ID: <AANLkTi=yrk-89CQqJG-2MBHnG3_HyvaCpgU7Fnb7CXqb@mail.gmail.com>
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

On Fri, Sep 10, 2010 at 1:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-09-02 at 15:07 -0400, Don Zickus wrote:
>> Fixes to allow unknown nmis to pass through the perf nmi handler instead
>> of being swallowed.  Contains patches that are already in Ingo's tree.  Added
>> here for completeness.  Based on ingo/tip
>>
>> Tested on intel/amd
>>
>> v2: patch cleanups and consolidation, no code changes
>>
>> Don Zickus (1):
>>   perf, x86: Fix accidentally ack'ing a second event on intel perf
>>     counter
>>
>> Peter Zijlstra (1):
>>   perf, x86: Fix handle_irq return values
>>
>> Robert Richter (1):
>>   perf, x86: Try to handle unknown nmis with an enabled PMU
>>
>>  arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
>>  arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
>>  arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
>>  3 files changed, 56 insertions(+), 20 deletions(-)
>
> Both Ingo and I are getting Dazed and confused on our AMD machines, it
> started before yesterday (that is, after backing out all my recent
> changes it still gets dazed), so I suspect this set.
>
> I'll look at getting a trace of the thing, but if any of you has a
> bright idea...

I still don't buy the back-to-back NMI thing. I suspect there is
something else going on. I have continued to track it down.
I got closer yesterday, until I ran into other issues. It may
have to do with throttling. I am still trying to understanding
why the OVF_STATUS does not match the check based on
the counter values.

>
