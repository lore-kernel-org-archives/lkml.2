Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab2ILOrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:47:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40780 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363Ab2ILOq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:46:59 -0400
MIME-Version: 1.0
In-Reply-To: <1347460719.15764.42.camel@twins>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	<1347459195-5491-2-git-send-email-eranian@google.com>
	<1347459984.15764.34.camel@twins>
	<CABPqkBSnhjgAhn5+gOuBWWPrxKojKW1hKPJEn7zvvYhiw-LPLg@mail.gmail.com>
	<1347460719.15764.42.camel@twins>
Date: Wed, 12 Sep 2012 16:46:57 +0200
Message-ID: <CABPqkBSCY1N8Zc9ZxRYmQykqg+hiukxW4ZRMWkp9wfaOSzgGrA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 4:38 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 16:33 +0200, Stephane Eranian wrote:
>
>>
>> If I do:
>>   for_each_possible_cpu(cpu) {
>>        cpuctx = per_cpu_ptr(pmu->pmu_cpu_context, cpu);
>>        hr = &cpuctx->hrtimer;
>>        hrtimer_init(hr)
>> }
>> I don't understand why I would have to refer to per-cpu data
>> (hrtimer_bases) from
>> a CPU that is not equal to "cpu" here. Unless you're telling me it's
>> read-only data.
>
> No its not read only, but it is unused until you do *hrtimer_start*(),
> which will test and fix.
>
>> But still if it's per-cpu why not initialize with the correct CPU from
>> the start?
>
> To keep the interface simpler I guess. There's no great harm in your
> proposal, but it is strictly speaking superfluous. I'm not sure the max
> one time avoidance of a base swizzle is worth the extra interface, I'll
> leave that up to Thomas.
>
> Also, what Eric said ;-)

I am fine with dropping this patch. I just found it odd there was a per-cpu
data reference embedded deep into the call. I wanted things to be more
explicit. I know it works without the proposed change.
