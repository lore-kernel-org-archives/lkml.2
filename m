Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0GLQMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:12:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0GLQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:12:52 -0400
Date: Mon, 12 Jul 2010 13:12:39 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 10/13]  perf: Re-Add make_absolute_path
Message-ID: <20100712161239.GF25238@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6>
 <20100712140023.GC25238@ghostprotocols.net>
 <1278945036.1537.189.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278945036.1537.189.camel@gandalf.stny.rr.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 12, 2010 at 10:30:36AM -0400, Steven Rostedt escreveu:
> On Mon, 2010-07-12 at 11:00 -0300, Arnaldo Carvalho de Melo wrote:
> > Also please remove the xstrdup and die calls from this function, we're
> > trying to get rid of all such 'panic' like functions so that we can
> > librarize as much code as possible.

> What I found useful with the "die" calls with trace-cmd is that I made
> them weak, and then they could be overwritten by apps. Thus, in
> kernelshark, the die and warning functions produce pop-ups and bug
> reports.

Well, I prefer to follow the kernel way of doing things, i.e. to
propagate as much as possible up the callchain the error return value,
so that the apps can handle it in any way they prefer, i.e. die() calls
in tools/perf/builtin-foo.c are okayish, but not on tools/perf/util/.

When I'm writing a tools/perf/builtin-.c file I also don't use die()
calls, as some routines may end up moving to the library, so its nice to
avoid them from the start.

The pr_{warning,err,info,etc} calls do something along the lines of what
you do, but not by marking them weak, the routine that is ultimately
called checks what kind of UI is being used and calls the appropriate
one (TUI/NEWT of stdio).

- Arnaldo
