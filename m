Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2HTKGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:06:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37884 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab2HTKGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:06:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120820094138.GA16230@one.firstfloor.org>
References: <20120820092421.GA11284@quad>
	<20120820094138.GA16230@one.firstfloor.org>
Date: Mon, 20 Aug 2012 12:06:42 +0200
Message-ID: <CABPqkBQREL4HpNoB_3BBbC1ecisuRYoCoMoATCkRFZAGzTchCA@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: enable Intel Cedarview Atom suppport
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 11:41 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
>> index 7f2739e..0d3d63a 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -2008,6 +2008,7 @@ __init int intel_pmu_init(void)
>>               break;
>>
>>       case 28: /* Atom */
>> +     case 54: /* Cedariew */
>
> Ack. We currently miss some more 32nm Atoms too, will send patches soon.
>
>>               memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
>>                      sizeof(hw_cache_event_ids));
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> index 520b426..da02e9c 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> @@ -686,7 +686,8 @@ void intel_pmu_lbr_init_atom(void)
>>        * to have an operational LBR which can freeze
>>        * on PMU interrupt
>>        */
>> -     if (boot_cpu_data.x86_mask < 10) {
>> +     if (boot_cpu_data.x86_model == 28
>> +         && boot_cpu_data.x86_mask < 10) {
>
> Is that correct?
>
Yes, had to do that to re-enable LBR on Cedarview.
The < 10 is a trick to disable LBR on very old Atom (prior to N4xx generation).
