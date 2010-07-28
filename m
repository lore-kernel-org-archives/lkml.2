Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0G1H4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:56:18 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52294 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0G1H4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:56:16 -0400
X-AuditID: b753bd60-a66d8ba000000a18-3a-4c4fe29c291c
Message-ID: <4C4FE299.4050207@hitachi.com>
Date: Wed, 28 Jul 2010 16:56:09 +0900
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
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111035.24690.27211.sendpatchset@localhost6.localdomain6> <4C4EDDAD.4010805@hitachi.com> <20100727140322.GB21723@linux.vnet.ibm.com>
In-Reply-To: <20100727140322.GB21723@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
>>> ---
>> [...]
>>> +/* Recursive argument parser */
>>> +static int parse_probe_arg(char *arg, const struct fetch_type *t,
>>> +		     struct fetch_param *f, int is_return, bool is_kprobe)
>> If you use "bool" for "is_kprobe", change "is_return" type too.
> 
> Okay. 
> 
> 
>> And, maybe you missed that the fetch function supports "string" type now,
>> which needs a bit different manner for storing fetched value. You can find
>> store_trace_args() function in trace_kprobe.c.
> 
> Yes, I have seen your changes for supporting string type.  Though all
> the fetch functions are in common code, uprobe based probes for now
> supports register fetching only. We have to add support for other
> types gradually. Please let me know if you see a reason to change the
> way we fetch even when we only support register type access.

Ah, OK. So uprobe-tracer restricts specifying string type on register :)

>> BTW, current fetch functions doesn't support fetching "paged-out" user-variables
>> because kprobe can't sleep inside its handler.
>> However, user-space memory can be paged out, and I assume that uprobes allows
>> its handler to I/O (and yield). If so, it can wait for accessing paged-out
>> variable, can't it?
> 
> Yes, the uprobes handler might sleep and hence we would have to
> handle accessing the paged-out user variables. When perf-uprobes
> starts supporting dwarf based probing, we should look into these
> issues.  Currently its a todo.

Great!

Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
