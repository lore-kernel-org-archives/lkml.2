Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab0HTJQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:16:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47861 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0HTJQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:16:46 -0400
Date: Fri, 20 Aug 2010 05:16:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100820091645.GA20138@infradead.org>
References: <20100815225359.GA32152@infradead.org>
 <20100819005720.GB5324@nowhere>
 <20100819085700.GB8782@infradead.org>
 <20100819150422.GA325@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819150422.GA325@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 12:04:22PM -0300, Arnaldo Carvalho de Melo wrote:
> 
> [acme@doppio tmp]$ perf report
> 
> http://vger.kernel.org/~acme/perf/perf-report-tui-callchain-xlog_sync.png
> 
> So it seems to work (you tell me if the callchains make sense), and the problem

I've rebuilt perf with libnewt to reproduce it, but to get any of the
callchain data I need to call perf report with a -g argument (which is
rather expected from the documentation anyway)

I still see the same problems as with the TUI perf report with that.
With the -g {mode},0.0 there is nothing to expand inside the GUI for
e.g. the pythong process, and with the 0.0 threshold I can only expand
a few 0.<something> callchains, but I never see the 80% your screenshot
shows.  What perf version are you running?

Also the flat mode is rendered incorrectly, it just adds different call
graphs inside a single process directly after each other instead of
separating them in the rendering.


