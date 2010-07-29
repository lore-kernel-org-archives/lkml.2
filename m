Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab0G2FE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:04:26 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60542 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab0G2FEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:04:22 -0400
X-AuditID: b753bd60-a88d0ba000005dcc-09-4c510bd1bb95
Message-ID: <4C510BCE.4010704@hitachi.com>
Date: Thu, 29 Jul 2010 14:04:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 9/14]  trace: uprobes trace_event interface
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100727111045.24690.31897.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index c681fa7..16e2a8c 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -482,6 +482,22 @@ config RING_BUFFER_BENCHMARK
>  
>  	  If unsure, say N.
>  
> +config UPROBE_EVENT
> +	bool "Enable uprobes-based dynamic events"
> +	depends on ARCH_SUPPORTS_UPROBES
> +	depends on MMU
> +	select UPROBES
> +	select PROBE_EVENTS
> +	select TRACING
> +	default n
> +	help
> +	  This allows the user to add tracing events on top of userspace dynamic
> +	  events (similar to tracepoints) on the fly via the traceevents interface.
> +	  Those events can be inserted wherever uprobes can probe, and record
> +	  various registers.
> +	  This option is required if you plan to use perf-probe subcommand of perf
> +	  tools on user space applications.
> +

Possible enhancement: Moving this config right after KPROBE_EVENT, because
 those two provide similar dynamic events.

Thank you,
-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
