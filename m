Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0GNUuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:50:06 -0400
Received: from mail.openrapids.net ([64.15.138.104]:56295 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754606Ab0GNUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:50:04 -0400
Date: Wed, 14 Jul 2010 16:50:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 10/13]  perf: Re-Add make_absolute_path
Message-ID: <20100714205001.GA2298@Krystal>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6> <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6> <20100712140023.GC25238@ghostprotocols.net> <1278945036.1537.189.camel@gandalf.stny.rr.com> <20100712161239.GF25238@ghostprotocols.net> <1279075767.4190.1.camel@localhost> <20100714162332.GA4000@ghostprotocols.net> <20100714204531.GA14474@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714204531.GA14474@elte.hu>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:46:52 up 172 days, 23:23,  6 users,  load average: 0.11, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > Em Tue, Jul 13, 2010 at 10:49:27PM -0400, Steven Rostedt escreveu:
> > > On Mon, 2010-07-12 at 13:12 -0300, Arnaldo Carvalho de Melo wrote:
> > > > Em Mon, Jul 12, 2010 at 10:30:36AM -0400, Steven Rostedt escreveu:
> > 
> > > > Well, I prefer to follow the kernel way of doing things, i.e. to
> > > > propagate as much as possible up the callchain the error return value,
> > > > so that the apps can handle it in any way they prefer, i.e. die() calls
> > > > in tools/perf/builtin-foo.c are okayish, but not on tools/perf/util/.
> > 
> > > Ah, yes, die is a bit strong. And I have been starting to avoid them
> > > too. Although, when malloc fails, it's almost certain that the app will
> > > die soon anyway ;-)
> > 
> > The interesting thing is that years ago, when modules were being introduced 
> > in the kernel and panic() calls for things like out of memory conditions 
> > were being removed, some people made the same comments, 'if that happens, 
> > you're doomed anyway!' :-)
> > 
> > I can see things like trying to load a huge perf.data file in the TUI 
> > interface failing and the user just being warned about it and going on with 
> > life loading some other file, etc.
> > 
> > Certainly it is interesting to try to apply as much as possible of the 
> > mindset (and fear of criticism) present when coding for the kernel when one 
> > codes for userland.
> 
> Yeah, and especially for perf the absolutely most important quality is 
> reliability. It's not just an app - it's a measurement tool. People rely on it 
> to reject or apply patches, on a daily basis.
> 
> perf must be very reliable and very dependable (and i'm happy that we managed 
> to achieve that goal so far :), and if it fails it should be apparent that it 
> failed and that results should not be relied on.
> 
> With other tools that are statistical i've sometimes seen a special type of 
> dangerous attitude of: "hey, it's just a sample, no biggie if it's lost, it's 
> just statistical anyway, lost in the noise" - but that's really a slippery 
> slope leading to a sloppy tool we cannot depend on 110%.
> 
> Just like physicists or engineers want to be able to trust their measurement 
> instruments, do we want kernel hackers to be able to trust the results of 
> perf.

I'm glad to see we're on the exact same page here. :)

Having reliable trace analysis tools is crucially important for both kernel
developers and end-users, especially when, as an example, someone try to use the
results to find out which is the "one" odd-case longest/shortest interrupt
handler during a day-long trace while trying to pinpoint a bug.

Thanks,

Mathieu

> 
> Thanks,
> 
> 	Ingo

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
