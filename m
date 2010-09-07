Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0IGQrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:47:45 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37113 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757123Ab0IGQrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:47:43 -0400
Date: Tue, 7 Sep 2010 12:47:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCHv11 2.6.36-rc2-tip 5/15]  5: uprobes: Uprobes
	(un)registration and exception handling.
Message-ID: <20100907164740.GA17491@Krystal>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6> <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6> <1283377414.2059.1729.camel@laptop> <20100903164219.GB1904@linux.vnet.ibm.com> <1283534349.2050.297.camel@laptop> <20100906174642.GG14891@linux.vnet.ibm.com> <20100906204042.GA19815@infradead.org> <20100907120258.GK14891@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907120258.GK14891@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:44:34 up 227 days, 19:21,  4 users,  load average: 0.11, 0.11,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srikar Dronamraju (srikar@linux.vnet.ibm.com) wrote:
> > On Mon, Sep 06, 2010 at 11:16:42PM +0530, Srikar Dronamraju wrote:
 [...]
> > 
> > Which btw, brings up two more issues, one in uprobes and one in perf.
> > For one even in userspace I think the dynamic probes will really just
> > be the tip of the iceberg and we'll get more bang for the buck from
> > static traces, which is something that's no supported in uprobes yet.
> > As a start supporting the dtrace-style sdt.h header would be a great
> > help, and then we can decide if we need somthing even better on top.
> 
> Yes, Static tracing using dtrace style sdt.h is a cool thing to do.
> Already SystemTap has this facility. However I think its probably
> better done at perf user interface level.

We currently have this feature in UST. We're adding "markers" into the
applications, and a UST daemon talks with an in-process library helper thread to
enable/disable markers and control tracing over unix sockets.

We're currently in the process of moving from markers to the
TRACE_EVENT()+tracepoints infrastructure.

Thanks,

Mathieu

> 
> The way I look at it is perf probe decodes the static markers and asks
> uprobes to place probepoints over there.
> Do you see a different approach? If yes can you tell what you were
> looking at?

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
