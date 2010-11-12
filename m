Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0KLK4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:56:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7396 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0KLK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:56:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sOhDm5QAIA7BEVhYAMvS8vdj0iRJni7OLgnWnTry/497Gx2WHcEhN3JAFSkZ8PZmX4
         JrZNtOrXG0sjHCm0zGkg==
MIME-Version: 1.0
In-Reply-To: <AANLkTin1Tw5x0J8iW5jNZJNN5t-8BBpt4qvQ84kGRzd=@mail.gmail.com>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<1289492117-18066-2-git-send-email-andi@firstfloor.org>
	<4CDC2DDD.50508@linux.vnet.ibm.com>
	<4CDC3845.4030104@linux.intel.com>
	<4CDC4628.8020109@linux.vnet.ibm.com>
	<20101111194936.GJ18718@basil.fritz.box>
	<1289505587.2084.193.camel@laptop>
	<AANLkTin3khDj2FpJ-SY+xhLykiKer23uAjRdBM4m8gXD@mail.gmail.com>
	<20101112104804.GB8020@basil.fritz.box>
	<AANLkTin1Tw5x0J8iW5jNZJNN5t-8BBpt4qvQ84kGRzd=@mail.gmail.com>
Date: Fri, 12 Nov 2010 11:56:08 +0100
Message-ID: <AANLkTim527zN4L2frSfJ0wKyiN1ROWG7NTDhbmORFnUe@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:52 AM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Nov 12, 2010 at 11:48 AM, Andi Kleen <andi@firstfloor.org> wrote:
>>> I don't think you need special syntax. You can simply come up with
>>> the 64-bit raw hex value. corey recently added a small utility to do
>>> this via libpfm4: perf stat -e `evt2raw unhalted_core_cycles:u` ....
>>
>> I added a small patch to perf to read event mappings from a flat mapping file.
>>
>>> > Also, I think we can use the same mechanism to program the
>>> > PEBS-load-latency MSR, right?
>>> >
>>> Yes, we could hardcode the latency the same way.
>>
>> At least right now it would still need a constraint, because only
>> one counter can use it.
>>
>
> True. But there are already contraint tables for PEBS. For instance,
> if I use INST_RETIRED (0x3c) with PEBS, then it cannot use a fixed
> counter. So you can do a constraint for MEM_LOAD_RETIRED:LAT_ABOVE_THRES
> the same way (include the umask).
>
Second thought on this. There is no contraint for the event
MEM_LOAD_RETIRED:LAT_ABOVE_THRES. It can be measured in any
of the 4 generic counters. It's just that it can only be measured once given
the extra MSR would then be shared. One way to implement this constraint
is indeed to mark the event has being able to run only in one counter. That
may be the simplest way to implement this. In that case I would use a
counter which does not have many other constraints, e.g. 3 or 4.
