Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0HUOmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 10:42:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0HUOml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 10:42:41 -0400
Date: Sat, 21 Aug 2010 10:42:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100821144239.GA31202@infradead.org>
References: <20100815225359.GA32152@infradead.org>
 <20100819005720.GB5324@nowhere>
 <20100819085700.GB8782@infradead.org>
 <20100819150422.GA325@ghostprotocols.net>
 <20100820091645.GA20138@infradead.org>
 <20100821024713.GD7959@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821024713.GD7959@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 04:47:14AM +0200, Frederic Weisbecker wrote:
> > I still see the same problems as with the TUI perf report with that.
> > With the -g {mode},0.0 there is nothing to expand inside the GUI for
>   ^^
>   you meant "without", right?

Yes, sorry.

> The following patch solves that particular problem, I'll push it to Ingo for .36
> (and -stable):

It does seem to fix the bug for some cases but not all.  Default perf
report in TUI and the normal command line seem to get it right.  perf
report -g flat still shows the old problem.  perf report -g flat,0.0
shows callgraphs, but just as before they just show the 0.<n>
percentages.

Btw, even in normal perf report mode the numbers while they look correct
confused me a bit.  The percentages before the callgraphs split are
always relative to the node above, not absolute which is rather
confusing.  And even despite adding -n to the perf report command line
I only get absolute numbers for the proccesses but not the actual
callgraphs.

> > Also the flat mode is rendered incorrectly, it just adds different call
> > graphs inside a single process directly after each other instead of
> > separating them in the rendering.
> 
> 
> I'm not sure what you mean. The flat format is a pure dump of every callchains
> that belong to a single process (or whatever kind of histogram source...).
> 
> What do you mean by separating them in the rendering?

If there are different callchains leading to the same tracepoint they
are just appened to each other with no visual indication that they are
separate callchains

