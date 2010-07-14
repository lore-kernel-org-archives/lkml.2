Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab0GNQYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:24:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:43566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab0GNQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:24:29 -0400
Date: Wed, 14 Jul 2010 13:23:32 -0300
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
Message-ID: <20100714162332.GA4000@ghostprotocols.net>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103412.27491.18737.sendpatchset@localhost6.localdomain6>
 <20100712140023.GC25238@ghostprotocols.net>
 <1278945036.1537.189.camel@gandalf.stny.rr.com>
 <20100712161239.GF25238@ghostprotocols.net>
 <1279075767.4190.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279075767.4190.1.camel@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 13, 2010 at 10:49:27PM -0400, Steven Rostedt escreveu:
> On Mon, 2010-07-12 at 13:12 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jul 12, 2010 at 10:30:36AM -0400, Steven Rostedt escreveu:

> > Well, I prefer to follow the kernel way of doing things, i.e. to
> > propagate as much as possible up the callchain the error return value,
> > so that the apps can handle it in any way they prefer, i.e. die() calls
> > in tools/perf/builtin-foo.c are okayish, but not on tools/perf/util/.

> Ah, yes, die is a bit strong. And I have been starting to avoid them
> too. Although, when malloc fails, it's almost certain that the app will
> die soon anyway ;-)

The interesting thing is that years ago, when modules were being
introduced in the kernel and panic() calls for things like out of memory
conditions were being removed, some people made the same comments, 'if
that happens, you're doomed anyway!' :-)

I can see things like trying to load a huge perf.data file in the TUI
interface failing and the user just being warned about it and going on
with life loading some other file, etc.

Certainly it is interesting to try to apply as much as possible of the
mindset (and fear of criticism) present when coding for the kernel when
one codes for userland.

- Arnaldo
