Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab0ERMUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:20:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab0ERMUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:20:04 -0400
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
In-Reply-To: <20100517224243.GA10603@Krystal>
References: <20100514183242.GA11795@Krystal>
	 <1273862945.1674.14.camel@laptop>  <20100517224243.GA10603@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 May 2010 14:19:20 +0200
Message-ID: <1274185160.5605.7787.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 18:42 -0400, Mathieu Desnoyers wrote:
> I'll continue to look into this. One of the things I noticed that that we could
> possibly use the "steal()" operation to steal the pages back from the page cache
> to repopulate the ring buffer rather than continuously allocating new pages. If
> steal() fails for some reasons, then we can fall back on page allocation. I'm
> not sure it is safe to assume anything about pages being in the page cache
> though. 

Also, suppose it was still in the page-cache and still dirty, a steal()
would then punch a hole in the file.

> Maybe the safest route is to just allocate new pages for now.

Yes, that seems to be the only sane approach.
