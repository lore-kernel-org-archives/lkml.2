Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0ERPQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:16:31 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40719 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754723Ab0ERPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:16:29 -0400
Date: Tue, 18 May 2010 11:16:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] Tracer Ring Buffer splice() vs page cache [was: Re: Perf
	and ftrace [was Re: PyTimechart]]
Message-ID: <20100518151626.GA7748@Krystal>
References: <20100514183242.GA11795@Krystal> <1273862945.1674.14.camel@laptop> <20100517224243.GA10603@Krystal> <1274185160.5605.7787.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274185160.5605.7787.camel@twins>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:13:42 up 115 days, 17:50, 10 users,  load average: 0.29, 0.32,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2010-05-17 at 18:42 -0400, Mathieu Desnoyers wrote:
> > I'll continue to look into this. One of the things I noticed that that we could
> > possibly use the "steal()" operation to steal the pages back from the page cache
> > to repopulate the ring buffer rather than continuously allocating new pages. If
> > steal() fails for some reasons, then we can fall back on page allocation. I'm
> > not sure it is safe to assume anything about pages being in the page cache
> > though. 
> 
> Also, suppose it was still in the page-cache and still dirty, a steal()
> would then punch a hole in the file.

page_cache_pipe_buf_steal starts by doing a wait_on_page_writeback(page); and
then does a try_to_release_page(page, GFP_KERNEL). Only if that succeeds is the
action of stealing succeeding.

> 
> > Maybe the safest route is to just allocate new pages for now.
> 
> Yes, that seems to be the only sane approach.

Yes, a good start anyway.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
