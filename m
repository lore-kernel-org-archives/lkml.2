Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab0GVN2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 09:28:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab0GVN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 09:27:58 -0400
X-Authority-Analysis: v=1.1 cv=0ETVU5ClxBlG/P3Ky9ZuhqraSVIot/cIDNO6awFX9oc= c=1 sm=0 a=3ezK_6wTyqwA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=xiHFxaFq04MNg9AoHu4A:9 a=fvd9mC2pur7yz7SwQbAA:7 a=Szqf-583lK8TrFYXntdr2gYcfYsA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH v1 04/15] perf: export tracepoint events via
 sysfs: sched, raw_syscalls etc.
From: Steven Rostedt <rostedt@goodmis.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1279797179.20942.85.camel@minggr.sh.intel.com>
References: <1279797179.20942.85.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jul 2010 09:27:53 -0400
Message-ID: <1279805273.3319.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 19:12 +0800, Lin Ming wrote:
> Below tracepoint events are exported under /sys/kernel/events/.
> sched, raw_syscalls, irq, timer, signal, workqueue, lock and bkl
> 

>  
> +/*
> + * tracepoint events: sched, raw_syscalls, irq, timer, signal,
> + * workqueue, lock and bkl are exported to
> + * /sys/kernel/events/
> + */
> +static void perf_sys_add_kernel_events(void)
> +{
> +	if (!sys_kernel_events_kobj)
> +		return;
> +
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "raw_syscalls");
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "sched");
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "irq");
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "timer");
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "signal");
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "workqueue");
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "lock");
> +	perf_sys_add_tp_events(sys_kernel_events_kobj, "bkl");

Why are these hard-coded and not create by the event system types?

-- Steve

> +}
> +


