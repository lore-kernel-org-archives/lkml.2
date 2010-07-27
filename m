Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0G0NXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 09:23:03 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40031 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0G0NXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 09:23:00 -0400
X-AuditID: b753bd60-a8cc1ba000005a63-59-4c4eddaf0ed1
Message-ID: <4C4EDDAD.4010805@hitachi.com>
Date: Tue, 27 Jul 2010 22:22:53 +0900
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
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 8/14]  trace: Extract out common code
 for kprobes/uprobes traceevents.
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111035.24690.27211.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100727111035.24690.27211.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srikar,

Srikar Dronamraju wrote:
> Move common parts of trace_kprobe.c and trace_uprobe.c
> Adjust kernel/trace/trace_kprobe.c after moving common code to
> kernel/trace/trace_probe.h and kernel/trace/trace_probe.c.
> 
> TODO: Merge both events to a single probe event.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
[...]
> +/* Recursive argument parser */
> +static int parse_probe_arg(char *arg, const struct fetch_type *t,
> +		     struct fetch_param *f, int is_return, bool is_kprobe)

If you use "bool" for "is_kprobe", change "is_return" type too.

And, maybe you missed that the fetch function supports "string" type now,
which needs a bit different manner for storing fetched value. You can find
store_trace_args() function in trace_kprobe.c.

BTW, current fetch functions doesn't support fetching "paged-out" user-variables
because kprobe can't sleep inside its handler.
However, user-space memory can be paged out, and I assume that uprobes allows
its handler to I/O (and yield). If so, it can wait for accessing paged-out
variable, can't it?

Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
