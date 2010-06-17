Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab0FQO0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:26:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0FQO0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:26:12 -0400
Date: Thu, 17 Jun 2010 11:25:46 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Add persistent events
Message-ID: <20100617142546.GA563@ghostprotocols.net>
References: <1275059860.27810.9635.camel@twins>
 <20100528155719.GA10141@kryptos.osrc.amd.com>
 <1275070030.1645.362.camel@laptop>
 <20100603134301.GA30880@kryptos.osrc.amd.com>
 <20100603173242.GD29202@ghostprotocols.net>
 <20100614192514.GA7803@kryptos.osrc.amd.com>
 <20100614210116.GA26716@ghostprotocols.net>
 <20100614212426.GA19915@liondog.tnic>
 <20100615010201.GA27077@ghostprotocols.net>
 <20100617134357.GA6115@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617134357.GA6115@kryptos.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 17, 2010 at 03:43:57PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Mon, Jun 14, 2010 at 10:02:01PM -0300
> > > however, this does not differentiate perflib (let's call it that for how
> > > :) from libc headers. Do we want a "perf" or "kernel" or "perflib" or
> > > whatever prefix here - it might make sense later when this thing grows
> > > to differentiate between the namespaces...?

> > Agreed, but the last name this thing will have will be 'perf'something :-)
> > One of the goals at least I have with pursuing this path is to separate
> > out everything that is not strictly 'perf' into things that can be reused
> > by other tools, like yours.

> I'm still splitting perf/util into a more or less generic lib.  Now, I
> want to reuse as much code as possible and am parsing the
> "mce:mce_record" tracepoint using parse_events(). However, this means
> that I have to push the not-so-generic perf bits like
> util/parse-events.c into the lib. Which, in turn, pulls in
> util/trace-event* etc.

I'm not that familiar with the trace bits in perf, but I'd say pick what
is needed for your tool and stash it into files in a tools/lib/trace/
directory, in a way that can be used by both perf and your tools.

I.e. no need to move files as-is, you can reorganize things to make it
useful for both perf and your tool.
 
> What is your preference, do we want to export all perf/util stuff for
> other tools to use or rather link other tools together with
> compilation modules from perf/util in case those other tools need
> them?

If we do it on a as-needed basis, as I suggested, we go eroding the
current perf hodgepodge of potentially generic stuff.
 
> I'm leaning towards the first one and am thinking "maximize code reuse"
> but I'm not completely sure, there might be reasons against it...

- Arnaldo
