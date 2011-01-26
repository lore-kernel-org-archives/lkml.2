Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1AZNNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:13:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:47906 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1AZNNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:13:33 -0500
Date: Wed, 26 Jan 2011 11:13:16 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd64.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] perf: Carve out mmap helpers for general use
Message-ID: <20110126131316.GA2511@ghostprotocols.net>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
 <1295622575-18607-9-git-send-email-bp@amd64.org>
 <20110121172937.GC15066@ghostprotocols.net>
 <20110124090410.GA8924@aftab>
 <20110124123936.GC5932@ghostprotocols.net>
 <20110126010002.GA10568@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126010002.GA10568@liondog.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 26, 2011 at 02:00:02AM +0100, Borislav Petkov escreveu:
> On Mon, Jan 24, 2011 at 10:39:36AM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jan 24, 2011 at 10:04:10AM +0100, Borislav Petkov escreveu:
> > I'm digressing, but twatch is an example of a simple "daemon" consuming
> > perf events where performance is not much of a problem.

> > And provides a prototyping ground when starting to design perf events
> > consuming daemons :-)

> Yaay, twatch looks almost like a child's play and even my grandma can
> profile her system now :).

> But yeah, I thought about pythonizing the ras thingy too but the
> reasons against it are that we might run on systems which don't have
> python, have some obscure/old version of it or we simply don't want to
> depend on it or any other additional tool for that matter. Generally,
> we want to run with as low overhead as possible when handling hw error
> info and be as self-contained as possible.

Right, that is why I try to have the python abstractions as close as
possible to the abstractions a C program, like your RAS thingy should
use.

I.e. one can go on introducing the kernel interfaces and testing them
using python, where you can, for instance, from the python interpreter
command line, create counters, read its values, i.e. test the kernel
stuff quickly and easily.

Moving to a C version then becomes easy after the testing phase is over
and the kernel bits are set in stone.

- Arnaldo
