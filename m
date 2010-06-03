Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0FCRdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:33:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:56312 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab0FCRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:33:09 -0400
Date: Thu, 3 Jun 2010 14:32:42 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@alien8.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100603173242.GD29202@ghostprotocols.net>
References: <1274640047.1674.1731.camel@laptop> <20100523185411.GA5608@liondog.tnic> <1274642601.1674.1755.camel@laptop> <20100525073246.GA6085@liondog.tnic> <1274799588.5882.1572.camel@twins> <20100528143311.GB9710@elte.hu> <1275059860.27810.9635.camel@twins> <20100528155719.GA10141@kryptos.osrc.amd.com> <1275070030.1645.362.camel@laptop> <20100603134301.GA30880@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603134301.GA30880@kryptos.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 03, 2010 at 03:43:01PM +0200, Borislav Petkov escreveu:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, May 28, 2010 at 08:07:10PM +0200
> > to allocate and attach a buffer to your event (do so for each cpu's MCE
> > event).
> > 
> > After that we still need a way to expose all that to userspace, but at
> > least the events will be complete and able to record bits ;-)
> 
> Yep, so far so good, the kernel side is almost done - this was the
> easy part :). So recently I started looking into how the userspace
> part could be done most efficiently so that, initially, the RAS daemon
> doesn't suck in all of tools/perf when building and depend unnecessary
> on libelf etc, and, at the same time, doesn't duplicate functionality
> like util/debugfs, get_debugfs_mntpt(), parse_events() maybe later etc.
> 
> So, the best way to do this, IMHO, is if I start carving out common and
> generic functionality into tools/lib/ or tools/util/ or similar so that
> perf and ras can share those. And maybe later even other tools. This
> could be where we host all the kernel headers stuff which are good for
> userspace, i.e. those which are in tools/perf/util/include/linux/
> 
> Opinions, comments?

Right, that has to be done, I have sample code I want to put in samples/
to show how to use the symbol libraries in tools/perf/util/, will take a
stab at moving things for tools/lib/.

We'll need a top level Makefile, I guess, so that when asking to build
tools/perf, it notices that it has to build tools/lib/, etc.

Probably we'll need tools/lib/symbols/, tools/lib/trace/parser/ things
like that, I'll start with the symbols part, using a samples/ file I
already wrote.

- Arnaldo
