Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1B1Ozt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:55:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1B1Ozr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:55:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lX32FlL18jcKKlH5mNCAac7PhcQb8x8i4Hc/V7OLeTX2NJbguQg1twmx4TbIT4wwt2
         QdbfEM644k0wSkJgCP7Q==
MIME-Version: 1.0
In-Reply-To: <1298904747.2169.56.camel@localhost>
References: <1298877772.4937.25.camel@minggr.sh.intel.com>
	<1298884559.2428.10083.camel@twins>
	<AANLkTims=DvdmDPET=G-_9w7Za2O_kkQhgQF8fKMV_x1@mail.gmail.com>
	<1298903626.2169.52.camel@localhost>
	<AANLkTinDBPsUaNhTOv7fgz-u3TWur08-HA3SpLt9s=BV@mail.gmail.com>
	<1298904747.2169.56.camel@localhost>
Date: Mon, 28 Feb 2011 15:55:45 +0100
Message-ID: <AANLkTimvBRs8ZzQSBWRZXdB8H_uYojs3bcw9d-E7VJWO@mail.gmail.com>
Subject: Re: [PATCH v2 -tip] perf: x86, add SandyBridge support
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 3:52 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Mon, 2011-02-28 at 22:43 +0800, Stephane Eranian wrote:
>> On Mon, Feb 28, 2011 at 3:33 PM, Lin Ming <ming.m.lin@intel.com> wrote:
>> > On Mon, 2011-02-28 at 20:25 +0800, Stephane Eranian wrote:
>> >> On Mon, Feb 28, 2011 at 10:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> >> > On Mon, 2011-02-28 at 15:22 +0800, Lin Ming wrote:
>> >> >> This patch adds basic SandyBridge support, including hardware cache
>> >> >> events and PEBS events support.
>> >> >>
>> >> >> LLC-* hareware cache events don't work for now, it depends on the
>> >> >> offcore patches.
>> >> >
>> >> > What's the status of those, Stephane reported some problems last I
>> >> > remember?
>> >> >
>> >> >
>> >> >>  #define INTEL_EVENT_CONSTRAINT(c, n) \
>> >> >>       EVENT_CONSTRAINT(c, n, ARCH_PERFMON_EVENTSEL_EVENT)
>> >> >> +#define INTEL_EVENT_CONSTRAINT2(c, n)        \
>> >> >> +     EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
>> >> >
>> >> > That's a particularly bad name, how about something like
>> >> >
>> >> > INTEL_UEVENT_CONSTRAINT or somesuch.
>> >> >
>> >> >> @@ -702,7 +738,13 @@ static void intel_ds_init(void)
>> >> >>                       printk(KERN_CONT "PEBS fmt1%c, ", pebs_type);
>> >> >>                       x86_pmu.pebs_record_size = sizeof(struct pebs_record_nhm);
>> >> >>                       x86_pmu.drain_pebs = intel_pmu_drain_pebs_nhm;
>> >> >> -                     x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
>> >> >> +                     switch (boot_cpu_data.x86_model) {
>> >> >> +                     case 42: /* SandyBridge */
>> >> >> +                             x86_pmu.pebs_constraints = intel_snb_pebs_events;
>> >> >> +                             break;
>> >> >> +                     default:
>> >> >> +                             x86_pmu.pebs_constraints = intel_nehalem_pebs_events;
>> >> >> +                     }
>> >> >>                       break;
>> >> >>
>> >> >>               default:
>> >> >
>> >> > We already have this massive model switch right after this function,
>> >> > might as well move the pebs constraint assignment there.
>> >> >
>> >> My PEBS  patch was going to cleanup this part, though it was using
>> >> it's own switch
>> >> statement.
>> >
>> > Did you send out the patch? A link?
>> >
>> For what?
>
> I mean your PEBS patch to do the cleanup.
>
I am updating it based on our discussion. Running a few tests and it should
be out today.
