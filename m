Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2ECVAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:00:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13898 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2ECVAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:00:31 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=bfYQkxlVB9AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=J9AP1unQCKHKdXilCjYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1336078827.14207.109.camel@gandalf.stny.rr.com>
Subject: Re: [PATCHv3 5/5] cpuidle: coupled: add trace events
From: Steven Rostedt <rostedt@goodmis.org>
To: Colin Cross <ccross@android.com>
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
Date: Thu, 03 May 2012 17:00:27 -0400
In-Reply-To: <1335816551-27756-6-git-send-email-ccross@android.com>
References: <1335816551-27756-1-git-send-email-ccross@android.com>
	 <1335816551-27756-6-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 13:09 -0700, Colin Cross wrote:

> diff --git a/include/trace/events/cpuidle.h b/include/trace/events/cpuidle.h
> new file mode 100644
> index 0000000..9b2cbbb
> --- /dev/null
> +++ b/include/trace/events/cpuidle.h
> @@ -0,0 +1,243 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM cpuidle
> +
> +#if !defined(_TRACE_CPUIDLE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_CPUIDLE_H
> +
> +#include <linux/atomic.h>
> +#include <linux/tracepoint.h>
> +
> +extern atomic_t cpuidle_trace_seq;
> +
> +TRACE_EVENT(coupled_enter,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_exit,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_spin,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_unspin,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_safe_enter,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_safe_exit,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_idle_enter,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_idle_exit,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_abort,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_detected_abort,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_poke,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);
> +
> +TRACE_EVENT(coupled_poked,
> +
> +	TP_PROTO(unsigned int cpu),
> +
> +	TP_ARGS(cpu),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned int, cpu)
> +		__field(unsigned int, seq)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->cpu = cpu;
> +		__entry->seq = atomic_inc_return(&cpuidle_trace_seq);
> +	),
> +
> +	TP_printk("%u %u", __entry->seq, __entry->cpu)
> +);

Egad! Please use DECLARE_EVENT_CLASS() and DEFINE_EVENT() when adding
events that are basically the same. Every TRACE_EVENT() can bloat the
kernel by 5k, using the DEFINE_EVENT()s keeps each event around just a
few hundred bytes.

See include/trace/events/ext4.h for examples.

-- Steve


> +
> +#endif /* if !defined(_TRACE_CPUIDLE_H) || defined(TRACE_HEADER_MULTI_READ) */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>


