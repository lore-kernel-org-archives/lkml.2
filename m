Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1B1MZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 07:25:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:61769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1B1MZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 07:25:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uTpHNwzSW2XHCJt2P63j/QPG/acHs21glqZnJsYbuaGDdWsW4dsNsSggNPy9IiXQlA
         bCGFSjxzfFT+h19JHDKA==
MIME-Version: 1.0
In-Reply-To: <1298884559.2428.10083.camel@twins>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	<1298884559.2428.10083.camel@twins>
Date: Mon, 28 Feb 2011 13:25:46 +0100
Message-ID: <AANLkTims=DvdmDPET=G-_9w7Za2O_kkQhgQF8fKMV_x1@mail.gmail.com>
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 10:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-02-28 at 15:22 +0800, Lin Ming wrote:
>> This patch adds basic SandyBridge support, including hardware cache
>> events and PEBS events support.
>>
>> LLC-* hareware cache events don't work for now, it depends on the
>> offcore patches.
>
> What's the status of those, Stephane reported some problems last I
> remember?
>
>
>>  #define INTEL_EVENT_CONSTRAINT(c, n) \
>>       EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
>> +#define INTEL_EVENT_CONSTRAINT2(c, n)        \
>> +     EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
>
> That's a particularly bad name, how about something like
>
> INTEL_UEVENT_CONSTRAINT or somesuch.
>
>> @@ -702,7 +738,13 @@ static void intel_ds_init(void)
>>                       printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
>>                       x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
>>                       x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
>> -                     x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
>> +                     switch (boot_cpu_data.x86_model) {
>> +                     case 42: /* SandyBridge */
>> +                             x86_pmu.pebs_constraints = intel_snb_pebs_events;
>> +                             break;
>> +                     default:
>> +                             x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
>> +                     }
>>                       break;
>>
>>               default:
>
> We already have this massive model switch right after this function,
> might as well move the pebs constraint assignment there.
>
My PEBS  patch was going to cleanup this part, though it was using
it's own switch
statement.
