Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab1BOSg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:36:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755566Ab1BOSgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:36:55 -0500
Date: Tue, 15 Feb 2011 16:35:58 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
	filtering
Message-ID: <20110215183558.GE30208@ghostprotocols.net>
References: <20110208015617.902200587@goodmis.org> <20110215044425.GA9994@elte.hu> <1297776787.23343.104.camel@gandalf.stny.rr.com> <1297787362.23343.109.camel@gandalf.stny.rr.com> <20110215165302.GA2272@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215165302.GA2272@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 15, 2011 at 05:53:06PM +0100, Frederic Weisbecker escreveu:
> On Tue, Feb 15, 2011 at 11:29:22AM -0500, Steven Rostedt wrote:
> > On Tue, 2011-02-15 at 08:33 -0500, Steven Rostedt wrote:
> > 
> > > Thanks for letting me waste three days on developing this. I even posted
> > > an RFC a while back, and no one complained then.
> > 
> > Sorry about being a bit bitchy in my reply here. I need to make a note
> > not to reply to LKML before my first cup of coffee. ;)
> > 
> > Arnaldo,
> > 
> > Thanks for the post, I'll help you out where you need it. trace-cmd has
> > some features that reports back to the user on failed filter usage. We
> > can incorporate that into perf.

Thanks!
 
> Cool!
> 
> That said I agree that we should not block improvements in the generic
> filtering code because of issues in perf uses of filters.
> 
> I believe it used to work better in perf by the past, but I saw similar
> issues lately like those Ingo noticed. So probably something
> broke and we need to investigate. But until then your patches are
> still nice improvements: lesser memory usage, lesser kernel stack usage in the
> fast path, lesser limitation, faster and smarter filter evaluation...

Yeah, usability of the --filter parameter in perf is a bit
(understatement) lacking, one has to look at the /format thing in
/sys/kernel/debug/tracing... and not commit any mistake, else a generic
invalid 22 message is spit out.

I tried it and after some back and forth changing hats and scratching my
head while doing so, it got to work.

I talked with Steven and the same operation using trace-cmd would
produce a better error report, stating that the field used in the filter
expression was not valid.

I'll try to get that code from trace-cmd and glue that into
tools/perf/util/, that eventually will get moved to tools/lib/ or
something like that, as Borislav has been experimenting with for some
time already.

The location in the source tree is not the most important thing at this
point, usability improvements are, so I'm not rushing to moving code
around all the time (even doing it more than I would like), lets try to
improve usability first and then we can move it to tools/lib.

- Arnaldo
