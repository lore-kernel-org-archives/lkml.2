Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab2ECVNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:13:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53649 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2ECVN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:13:28 -0400
MIME-Version: 1.0
In-Reply-To: <1336078827.14207.109.camel@gandalf.stny.rr.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
	<1335816551-27756-6-git-send-email-ccross@android.com>
	<1336078827.14207.109.camel@gandalf.stny.rr.com>
Date: Thu, 3 May 2012 14:13:27 -0700
X-Google-Sender-Auth: WesVK0-DxJObSvox80gR-9FsbYo
Message-ID: <CAMbhsRQWwp6TLVbHefV5c0fsb0W5=B_EVEdWtHcwc799dWEHGg@mail.gmail.com>
Subject: Re: [PATCHv3 5/5] cpuidle: coupled: add trace events
From: Colin Cross <ccross@android.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 2:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-04-30 at 13:09 -0700, Colin Cross wrote:
>
>> diff --git a/include/trace/events/cpuidle.h b/include/trace/events/cpuidle.h
>> new file mode 100644
>> index 0000000..9b2cbbb
>> --- /dev/null
>> +++ b/include/trace/events/cpuidle.h
>> @@ -0,0 +1,243 @@
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM cpuidle
>> +
>> +#if !defined(_TRACE_CPUIDLE_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_CPUIDLE_H
>> +
>> +#include <linux/atomic.h>
>> +#include <linux/tracepoint.h>
>> +
>> +extern atomic_t cpuidle_trace_seq;
>> +
>> +TRACE_EVENT(coupled_enter,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_exit,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_spin,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_unspin,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_safe_enter,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_safe_exit,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_idle_enter,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_idle_exit,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_abort,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_detected_abort,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_poke,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>> +
>> +TRACE_EVENT(coupled_poked,
>> +
>> +     TP_PROTO(unsigned int cpu),
>> +
>> +     TP_ARGS(cpu),
>> +
>> +     TP_STRUCT__entry(
>> +             __field(unsigned int, cpu)
>> +             __field(unsigned int, seq)
>> +     ),
>> +
>> +     TP_fast_assign(
>> +             __entry->cpu = cpu;
>> +             __entry->seq = atomic_inc_return(&cpuidle_trace_seq);
>> +     ),
>> +
>> +     TP_printk("%u %u", __entry->seq, __entry->cpu)
>> +);
>
> Egad! Please use DECLARE_EVENT_CLASS() and DEFINE_EVENT() when adding
> events that are basically the same. Every TRACE_EVENT() can bloat the
> kernel by 5k, using the DEFINE_EVENT()s keeps each event around just a
> few hundred bytes.
>
> See include/trace/events/ext4.h for examples.

Thanks, I'll take a look.  There is no mention in Documentation/ or
samples/ of DECLARE_EVENT_CLASS() or DEFINE_EVENT(), nor any mention
of the cost of TRACE_EVENT().

Looking at the new power tracing code, I will also rework these events
to be more similar to the existing ones.

I suggest skipping this patch for 3.5, and I'll post an updated one for 3.6.
