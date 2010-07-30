Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab0G3OPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:15:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41963 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0G3OPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CU7+jcOhmN581j5oo32hlH/WR4COM4rZNHPvym/rEa8H+GbD9dRKDicvfSGq0Q+sjF
         eMKUuROmGOnsSPlOrI+0ClBw/RzOQcwbFBDsVc53PiCKS0a1kmXByhY+UpHTbVSF16D0
         lmLZbeebDI3FaBwPaZoqmTAM3UlhY35eSo/ck=
Date: Fri, 30 Jul 2010 16:15:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/6] vmscan: tracing: Roll up of patches currently in
	mmotm
Message-ID: <20100730141552.GC5269@nowhere>
References: <1280497020-22816-1-git-send-email-mel@csn.ul.ie> <1280497020-22816-2-git-send-email-mel@csn.ul.ie> <20100730140441.GB5269@nowhere> <20100730141217.GG3571@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100730141217.GG3571@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 03:12:18PM +0100, Mel Gorman wrote:
> On Fri, Jul 30, 2010 at 04:04:42PM +0200, Frederic Weisbecker wrote:
> > On Fri, Jul 30, 2010 at 02:36:55PM +0100, Mel Gorman wrote:
> > > This is a roll-up of patches currently in mmotm related to stack reduction and
> > > tracing reclaim. It is based on 2.6.35-rc6 and included for the convenience
> > > of testing.
> > > 
> > > No signed off required.
> > > ---
> > >  .../trace/postprocess/trace-vmscan-postprocess.pl  |  654 ++++++++++++++++++++
> > 
> > I have the feeling you've made an ad-hoc post processing script that seems
> > to rewrite all the format parsing, debugfs, stream handling, etc... we
> > have that in perf tools already.
> > 
> 
> It's an hoc adaption of trace-pagealloc-postprocess.pl which was developed
> before the perf scripting report. It's a bit klunky.
> 
> > May be you weren't aware of what we have in perf in terms of scripting support.
> > 
> 
> I'm aware, I just haven't gotten around to adapting what the script does
> to the perf scripting support. The existance of the script I have means
> people can reproduce my results without having to wait for me to rewrite
> the post-processing scripts for perf.
> 
> > First, launch perf list and spot the events you're interested in, let's
> > say you're interested in irqs:
> > 
> > $ perf list
> >   [...]
> >   irq:irq_handler_entry                      [Tracepoint event]
> >   irq:irq_handler_exit                       [Tracepoint event]
> >   irq:softirq_entry                          [Tracepoint event]
> >   irq:softirq_exit                           [Tracepoint event]
> >   [...]
> > 
> > Now do a trace record:
> > 
> > # perf record -e irq:irq_handler_entry -e irq:irq_handler_exit -e irq:softirq_entry -e irq:softirq_exit cmd
> > 
> > or more simple:
> > 
> > # perf record -e irq:* cmd
> > 
> > You can use -a instead of cmd for wide tracing.
> > 
> > Now generate a perf parsing script on top of these traces:
> > 
> > # perf trace -g perl
> > generated Perl script: perf-trace.pl
> > 
> > Fill up the trace handlers inside perf-trace.pl and just run it:
> > 
> > # perf trace -s perf-trace.pl
> > 
> > Once ready, you can place your script in the script directory.
> > 
> 
> Ultimately, the post-processing scripts should be adapted to perf but it
> could be a while before I get around to it.


Ok, I thought it was a brand new thing. No problem then.

