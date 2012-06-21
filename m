Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2FUNIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 09:08:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39716 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583Ab2FUNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 09:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <CABPqkBSV7MwALrv1Sah6L9C2FP=AGXC2+yeN=jsJk=HrO1bNzA@mail.gmail.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	<1340208092.21745.114.camel@twins>
	<4FE28823.80704@intel.com>
	<CABPqkBTi8-yKg_kzFTwLe1_m2Zprt5vGk9WPQW14yHQpy=PiWw@mail.gmail.com>
	<4FE2DE9A.70202@intel.com>
	<CABPqkBTESKqVG6shXsLi85w=ZJ=1hXxu8+_7tNp23euds8JPbg@mail.gmail.com>
	<1340278853.21745.178.camel@twins>
	<CABPqkBSV7MwALrv1Sah6L9C2FP=AGXC2+yeN=jsJk=HrO1bNzA@mail.gmail.com>
Date: Thu, 21 Jun 2012 21:08:22 +0800
X-Google-Sender-Auth: j793Zm5H1U4r2A3oqFqbC-czqVE
Message-ID: <CAAM7YAkyZb6p0Nhsft4NvyTH0WFeekwG74MozkToUj2kuEqPDw@mail.gmail.com>
Subject: Re: [PATCH V6 0/13] perf: Intel uncore pmu counting support
From: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 7:48 PM, Stephane Eranian <eranian@google.com> wrote:
> On Thu, Jun 21, 2012 at 1:40 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> On Thu, 2012-06-21 at 11:13 +0200, Stephane Eranian wrote:
>>
>>> >>> How about treat the 'cpu' parameter for uncore event as socket id instead
>>> >>> of cpu id?
>>> >>>
>>> >> But that does not address the use case of Peter, i.e., no cpu parameter passed.
>>> >> Looks like sysfs might be the only way to do this in a portable manner.
>>> >>
>>> > It does. For example, on a dual socket system, perf can only register uncore
>>> > counter with 'cpu' parameter is equal to 0 or 1. This method is hacky, but it
>>> > requires minimal change for the kernel and perf tool.
>>> >
>>> I was saying, I don't want to have to pass -C x with -a and yet have perf stat
>>> only instantiate the event once per socket. I think that's what PeterZ was
>>> asking about.
>>
>> What Zheng is saying is that -a will iterate [0..nr_cpus), but since
>> we're interpreting the sys_perf_event_open(.cpu) argument as node, we'll
>> fail the syscall with -EINVAL or so for .cpu >= nr_node_ids.
>>
> Ok, but how do you distinguish EINVAL is this case from an error with a non
> uncore event? Unless you return a unique error code, I don't see how you'd solve
> that. In general, I don't like it when perf switches events or CPUs under the
> cover.
>
> When happens with -a -A?
>
>
>> This way, we'll only create one counter per node.
>>
>> I would work, but its not pretty since we still don't know what we're
>> iterating.
>
> Not pretty.

Ok, I will try implementing the sysfs link approach that Peter suggested.

Thanks
Yan, Zheng
