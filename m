Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab0FNVBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:01:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:58910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab0FNVBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:01:45 -0400
Date: Mon, 14 Jun 2010 18:01:16 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <bp@alien8.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100614210116.GA26716@ghostprotocols.net>
References: <1274642601.1674.1755.camel@laptop>
 <20100525073246.GA6085@liondog.tnic>
 <1274799588.5882.1572.camel@twins>
 <20100528143311.GB9710@elte.hu>
 <1275059860.27810.9635.camel@twins>
 <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
 <20100614192514.GA7803@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100614192514.GA7803@kryptos.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 14, 2010 at 09:25:14PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Thu, Jun 03, 2010 at 02:32:42PM -0300
> 
> > Right, that has to be done, I have sample code I want to put in samples/
> > to show how to use the symbol libraries in tools/perf/util/, will take a
> > stab at moving things for tools/lib/.
> > 
> > We'll need a top level Makefile, I guess, so that when asking to build
> > tools/perf, it notices that it has to build tools/lib/, etc.
> > 
> > Probably we'll need tools/lib/symbols/, tools/lib/trace/parser/ things
> > like that, I'll start with the symbols part, using a samples/ file I
> > already wrote.
> 
> Right, so I started playing with this, added a global Makefile to tools/
> and from there we descend into lib/ and perf/ in that order to prepare
> all the modules for the perflib. I've played with the include paths so
> that you can have #include <util/util.h> for all that generic library
> stuff.
> 
> The patch below carves out the debugfs helpers along with some generic
> headers, please take a look and let me know if this is an agreeable
> direction I'm going. Yeah, it is big, I think vger won't be able to
> swallow it but this is only moving files around so...

One thing I thought was that perhaps reusing Kbuild would be a good
idea, something like:

cd tools/
make menuconfig

And use all the Kbuild machinery to select needed features, etc.

What do you think?

It can be a follow up to what you're doing, that is needed anyway, some
questions below:
 
> Thanks.
> 
> --
> >From 0f391f0acf39d3b2e85145dce389cbf425cb7cdd Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Mon, 14 Jun 2010 21:14:15 +0200
> Subject: [PATCH] perf: rewire generic library stuff
> 
> ---
>  tools/Makefile                                     |   74 +++++
>  tools/lib/Makefile                                 |   41 +++
>  tools/lib/util/cache.h                             |   86 ++++++
>  tools/lib/util/debugfs.c                           |  252 +++++++++++++++++
>  tools/lib/util/debugfs.h                           |   31 +++
>  tools/lib/util/strbuf.c                            |  133 +++++++++
>  tools/lib/util/strbuf.h                            |   92 +++++++
>  tools/lib/util/types.h                             |   17 ++
>  tools/lib/util/util.h                              |  282 ++++++++++++++++++++

Will we continue using "util" here? What other name could we pick? Nah,
probably for the ones you moved we can continue using it, the symbols
part I plan to move to tools/lib/symbol/.

>  tools/perf/Makefile                                |   64 +----
>  tools/perf/bench/bench.h                           |    2 +
>  tools/perf/bench/mem-memcpy.c                      |    2 +-
>  tools/perf/bench/sched-messaging.c                 |    2 +-
>  tools/perf/bench/sched-pipe.c                      |    2 +-
>  tools/perf/builtin-bench.c                         |    2 +-
>  tools/perf/builtin.h                               |    4 +-

> -#include "types.h"
> +#include <util/types.h>

I thought about suggesting using -I to reduce patch size, but then it is
using "" :-\

So I'll do some testing here and merge this for .36 unless somebody has
other issues with this, Ingo? Frédéric?

- Arnaldo
