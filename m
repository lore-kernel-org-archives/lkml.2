Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132Ab0ENSty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:49:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084Ab0ENStw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:49:52 -0400
Subject: Re: [RFC] Tracer Ring Buffer splice() vs page cache [was: Re: Perf
 and ftrace [was Re: PyTimechart]]
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
In-Reply-To: <20100514183242.GA11795@Krystal>
References: <20100514183242.GA11795@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 20:49:05 +0200
Message-ID: <1273862945.1674.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 14:32 -0400, Mathieu Desnoyers wrote:

> [CCing memory management specialists]

And jet you forgot Jens who wrote it ;-)

> So I have three questions here:
> 
> 1 - could we enforce removal of these pages from the page cache by calling
>     "page_cache_release()" before giving these pages back to the ring buffer ?
> 
> 2 - or maybe is there a page flag we could specify when we allocate them to
>     ask for these pages to never be put in the page cache ? (but they should be
>     still usable as write buffers)
> 
> 3 - is there something more we need to do to grab a reference on the pages
>     before passing them to splice(), so that when we call page_cache_release()
>     they don't get reclaimed ? 

There is no guarantee it is the pagecache they end up in, it could be a
network packet queue, a pipe, or anything that implements .splice_write.

>From what I understand of splice() is that it assumes it passes
ownership of the page, you're not supposed to touch them again, non of
the above three are feasible.



