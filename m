Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab1LFNol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:44:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:50788 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab1LFNoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:44:37 -0500
Date: Tue, 6 Dec 2011 11:44:31 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH] perf top: fix crash on annotate request
Message-ID: <20111206134431.GA10709@infradead.org>
References: <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net>
 <4E9F4B50.1060207@gmail.com>
 <20111020130041.GB1772@ghostprotocols.net>
 <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
 <CAHVUoiTeCuFLCkyEzCMJ6g1wAp+FWDR3qkSrqE3vJAYwLsRC9Q@mail.gmail.com>
 <20111130181011.GA4111@infradead.org>
 <CAHVUoiQC5RjuHUsfPVTQ_C+W0Khp=hQC+_csP0+fJgUnoaALAA@mail.gmail.com>
 <20111201141130.GA2323@infradead.org>
 <CAHVUoiR=gMcdLZcR+TmB6CiRhEP+x8aXjR5r5Wc4k6gZwzLAjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVUoiR=gMcdLZcR+TmB6CiRhEP+x8aXjR5r5Wc4k6gZwzLAjg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 06, 2011 at 10:22:57AM +0300, Brian Gitonga Marete escreveu:
> On Thu, Dec 1, 2011 at 5:11 PM, Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > Its just this one, can you try doing something like:

> > perf top -vvv > /tmp/debug.top 2>&1
> > bzip2 /tmp/debug.top

> > That will print lots of information about symbols being loaded,
> > overlapping maps, etc that can help me understand why that symbol name
> > looks garbage.

> > And send me in pvt the result together with a fresh backtrace with those
> > symbols printed? Also which distro are you using?

> Hello Arnaldo. Curiously, I am unable to reproduce the crash when
> stdout is redirected to a file. I am able to capture lots of output if

That is good input, so can you please try using just:

perf top --stdio

I.e. probably the problem is with the TUI code and running it in --stdio
mode will help us pinpoint that. No need to redirect anything.

> I redirect stdout to a file in verbose mode, but it won't crash when I
> do that. Just the same, I am still able to always reproduce (within a
> few seconds) with your perf/core branch on the tree you pointed me to.
> This time, I did a `thread apply all bt' in gdb to show the trace for
> the UI thread since it now seems to me to probably have something with
> the UI output (because I cannot reproduce if o/put is to a file). The
> trace is attached in the file gdb.txt.
 
> Is the `perf top -vvv > /tmp/debug.top 2>&1' output useful even if it
> is captured in a session that does not crash? If so will send the
> output privately to you.

please.
 
> I am using Ubuntu 10.10

Ok,

- Arnaldo
