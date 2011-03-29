Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1C2RqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:46:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1C2RqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:46:07 -0400
Date: Tue, 29 Mar 2011 14:45:56 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
Message-ID: <20110329174556.GC24129@ghostprotocols.net>
References: <1301391136.14111.98.camel@minggr.sh.intel.com> <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost> <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop> <1301418533.2250.419.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301418533.2250.419.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 29, 2011 at 07:08:53PM +0200, Peter Zijlstra escreveu:
> On Tue, 2011-03-29 at 19:06 +0200, Peter Zijlstra wrote:
> > On Tue, 2011-03-29 at 19:03 +0200, Peter Zijlstra wrote:
> > > > Is it an unwind of the call frame stack to find out what data member was
> > > > accessed?

> > > No need to unwind stacks, DWARF should have information on function
> > > local stack. It should be able to tell you the type of things like -8(%
> > > rbp). 

> > That is, we don't even have a life stack to unwind, so we simply cannot
> > unwind at all, but the debug information should be able to tell you the
> > type of whatever would live at a certain stack position if we were to
> > have a stack.

> Furthermore, I've now completely exhausted my knowledge of debuginfo and
> hope Masami and Arnaldo will help with further details ;-)

:-)

I think the place to look is 'perf probe', look for the way one
variable is translated to an expression passed to the kprobe_tracer, I
think you'll need the reverse operation.

Look at tools/perf/util/probe-finder.c, function find_variable() and
convert_variable_location().

Understanding how those functions use the dwarf_ prefixed routines from
libdw should be a good start.

- Arnaldo
