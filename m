Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0IGMJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:09:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60779 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab0IGMJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:09:14 -0400
Date: Tue, 7 Sep 2010 17:32:58 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Message-ID: <20100907120258.GK14891@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134224.5447.89998.sendpatchset@localhost6.localdomain6>
 <1283377414.2059.1729.camel@laptop>
 <20100903164219.GB1904@linux.vnet.ibm.com>
 <1283534349.2050.297.camel@laptop>
 <20100906174642.GG14891@linux.vnet.ibm.com>
 <20100906204042.GA19815@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100906204042.GA19815@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Sep 06, 2010 at 11:16:42PM +0530, Srikar Dronamraju wrote:
> > > You don't have to, but you can. The problem I have with this stuff is
> > > that it makes the pid thing a primary interface, whereas it should be
> > > one of many filter possibilities.
> > 
> > I think the otherway, 
> > Why instrument a process and filter it out, if we are not interested in it.
> > While instrumenting kernel, we dont have this flexibility. So
> > having a pid based filter is the right thing to do for kernel
> > based tracing.
> > 
> > If we can get the per process based tracing right, we can build
> > higher lever stuff including the file based tracing easily.
> > 
> > All tools/debuggers in the past have all worked with process based
> > tracing.
> 
> I have the feeling that you guys are at least partially talking past
> each other.
> 
> For the "perf probe --add" interface the only sane interface is one by
> filename and then symbol / liner number / etc.

Agree, probing by file name is a requirement and I am working
towards that end.
> 
> But that is just the interface - these probes don't nessecarily have to
> be armed and cause global overhead once they are define.  If the
> implenmentation is smart enough it will defer arming the probe until
> we actually use it, and that will be per-process quite often.

Agree, That why I am trying to build file-based probing on
pid-based probing.

> 
> Which btw, brings up two more issues, one in uprobes and one in perf.
> For one even in userspace I think the dynamic probes will really just
> be the tip of the iceberg and we'll get more bang for the buck from
> static traces, which is something that's no supported in uprobes yet.
> As a start supporting the dtrace-style sdt.h header would be a great
> help, and then we can decide if we need somthing even better on top.

Yes, Static tracing using dtrace style sdt.h is a cool thing to do.
Already SystemTap has this facility. However I think its probably
better done at perf user interface level.

The way I look at it is perf probe decodes the static markers and asks
uprobes to place probepoints over there.
Do you see a different approach? If yes can you tell what you were
looking at?


--
Thanks and Regards
Srikar
