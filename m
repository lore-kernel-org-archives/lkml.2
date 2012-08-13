Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab2HMSDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:03:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:44225 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2HMSDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:03:02 -0400
Date: Mon, 13 Aug 2012 15:02:49 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
Message-ID: <20120813180249.GB6840@infradead.org>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
 <20120813132438.GA18990@aftab.osrc.amd.com>
 <1344867782.6935.119.camel@gandalf.stny.rr.com>
 <20120813142909.GC18990@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813142909.GC18990@aftab.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 13, 2012 at 04:29:09PM +0200, Borislav Petkov escreveu:
> On Mon, Aug 13, 2012 at 10:23:02AM -0400, Steven Rostedt wrote:
> > On Mon, 2012-08-13 at 15:24 +0200, Borislav Petkov wrote:
> > 
> > > So wouldn't it make sense to call this ABSOLUTE_O or so then?
> > 
> > That's just because you're russian, and are promoting Vodka! ;-)

Before:

[acme@sandy linux]$ rm -rf ../build/perf
[acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
/bin/sh: line 0: cd: /home/acme/git/build/perf/: No such file or directory
make: Entering directory `/home/git/linux/tools/perf'
../scripts/Makefile.include:9: *** output directory "/home/acme/git/build/perf/" does not exist.  Stop.
make: Leaving directory `/home/git/linux/tools/perf'
[acme@sandy linux]$

Now:

[acme@sandy linux]$ rm -rf ../build/perf
[acme@sandy linux]$ make -j8 -C tools/perf/ LIBUNWIND_DIR=/opt/libunwind O=/home/acme/git/build/perf install
/bin/sh: line 0: cd: /home/acme/git/build/perf: No such file or directory
make: Entering directory `/home/git/linux/tools/perf'
    GEN perf-archive
    GEN /home/git/linux/tools/perf/python/perf.so
make[1]: Entering directory `/home/git/linux/tools/lib/traceevent'
make[2]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
    * new build flags or cross compiler
    CC /home/git/linux/tools/perf/perf.o
    CC /home/git/linux/tools/perf/builtin-annotate.o
    CC /home/git/linux/tools/perf/builtin-bench.o
    CC /home/git/linux/tools/perf/bench/sched-messaging.o
    CC /home/git/linux/tools/perf/bench/sched-pipe.o

I.e. it should stop if the O= provided directory is not there.

Can you fix this? Avoid vodka while doing it :-P

- Arnaldo
