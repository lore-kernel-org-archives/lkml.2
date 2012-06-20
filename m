Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2FTKqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:46:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35992 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2FTKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:46:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120620100031.GI1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
	<CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
	<20120620092932.GH1478@erda.amd.com>
	<1340185084.21745.81.camel@twins>
	<20120620100031.GI1478@erda.amd.com>
Date: Wed, 20 Jun 2012 12:46:21 +0200
Message-ID: <CABPqkBRzeSB4SHMSnGbu+HfPyVMSwCUHKoeoa68UF4VrjjxKsQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for AMD
 family 15h
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:00 PM, Robert Richter <robert.richter@amd.com> wrote:
> On 20.06.12 11:38:04, Peter Zijlstra wrote:
>> On Wed, 2012-06-20 at 11:29 +0200, Robert Richter wrote:
>> > Second, since nb perfctr are implemented the same way as core
>> > counters, the same code would have been used. Thus multiple (two) x86
>> > pmus (struct x86_pmu) would reside in parallel in the kernel.
>>
>> Well, no. The I take it the uncore counters are nb wide, thus you need
>> special goo to make counter rotation work properly, x86_pmu is unsuited
>> for that.
>
> The code for nb and core counters is identical. There would be the
> same nmi handler, same code to setup the event, same code to
> start/stop cpus. The only difference are per-node msrs, even the msr
> offset calculation is the same as for core counters on family 15h. It
> would not make sense to duplicate all this code. And, as said, current
> design does not fit to use x86_pmus in parallel or to easy reuse x86
> functions. Separating nb counters would make the same sense as
> implementing a separate pmu for fixed counters.
>
Being identical does not necessarily mean you have to copy the code,
you can also simply call it.

I don't see the explanation for the non-contiguous counter indexes.
What's that about? With a separate PMU, would you have that problem.
I see uncore CTL base MSRC001_0240, next is 0242, and so on. But
that's already the case with core counters on Fam15h.

As Peter said, having your own PMU would alleviate the need for
Patch 10. Those filters would simply not be visible to tools via
sysfs.

> And wrt counter rotation, this only affects code to assign counters.
> You don't need a separate pmu for this.
>
> -Robert
>
> --
> Advanced Micro Devices, Inc.
> Operating System Research Center
>
