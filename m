Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0FONWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:22:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0FONWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:22:24 -0400
Date: Tue, 15 Jun 2010 10:22:02 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100615132202.GB27077@ghostprotocols.net>
References: <1275059860.27810.9635.camel@twins>
 <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
 <20100614192514.GA7803@kryptos.osrc.amd.com>
 <20100614210116.GA26716@ghostprotocols.net>
 <20100614212426.GA19915@liondog.tnic>
 <20100615010201.GA27077@ghostprotocols.net>
 <20100615102259.GB17953@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100615102259.GB17953@aftab>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 15, 2010 at 12:22:59PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Mon, Jun 14, 2010 at 09:02:01PM -0400
> 
> > Em Mon, Jun 14, 2010 at 11:24:26PM +0200, Borislav Petkov escreveu:
> > > From: Arnaldo Carvalho de Melo <acme@infradead.org>
> > > > From: Arnaldo Carvalho de Melo <acme@infradead.org>
> > > > Will we continue using "util" here? What other name could we pick? Nah,
> > > > probably for the ones you moved we can continue using it, the symbols
> > > > part I plan to move to tools/lib/symbol/.
> > > Em Mon, Jun 14, 2010 at 11:24:26PM +0200, Borislav Petkov escreveu:
> > > Yeah, names are kinda arbitrary. Keeping "util" meant as little changes as
> > > possible but it would make more sense to simply have all different library
> > > modules under "tools/lib/<module>.(c|h)" Will do so in the next version.
> > 
> > Ok
> > 
> > > > >  tools/perf/builtin-bench.c                         |    2 +-
> > > > >  tools/perf/builtin.h                               |    4 +-
> > > > 
> > > > > -#include "types.h"
> > > > > +#include <util/types.h>
> > > > 
> > > > I thought about suggesting using -I to reduce patch size, but then it is
> > > > using "" :-\
> > > 
> > > Yeah, I have the -I$(CURDIR)/lib for this in the top level Makefile so all
> > > library includes would be like:
> > > 
> > > #include <util.h>
> > > 
> > > however, this does not differentiate perflib (let's call it that for how
> > > :) from libc headers. Do we want a "perf" or "kernel" or "perflib" or
> > > whatever prefix here - it might make sense later when this thing grows
> > > to differentiate between the namespaces...?
> > 
> > Agreed, but the last name this thing will have will be 'perf'something :-)
> > 
> > One of the goals at least I have with pursuing this path is to separate
> > out everything that is not strictly 'perf' into things that can be reused
> > by other tools, like yours.
> 
> Ok, since I'm a big fan of unambiguous short names, let's call it "lk"
> for "linux kernel" and have this namespace for all generic headers. So
> when you include those, you have something like
> 
> #include <lk/util.h>
> 
> How does that sound?

As this code originated on the Linux kernel, should be OK and probably
unused.

Peter, ideas?

- Arnaldo
