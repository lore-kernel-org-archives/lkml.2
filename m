Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab0ERPYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:24:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab0ERPYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:24:44 -0400
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
In-Reply-To: <20100518151626.GA7748@Krystal>
References: <20100514183242.GA11795@Krystal>
	 <1273862945.1674.14.camel@laptop> <20100517224243.GA10603@Krystal>
	 <1274185160.5605.7787.camel@twins>  <20100518151626.GA7748@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 18 May 2010 17:23:53 +0200
Message-ID: <1274196233.5605.8169.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 11:16 -0400, Mathieu Desnoyers wrote:
> > Also, suppose it was still in the page-cache and still dirty, a steal()
> > would then punch a hole in the file.
> 
> page_cache_pipe_buf_steal starts by doing a wait_on_page_writeback(page); and
> then does a try_to_release_page(page, GFP_KERNEL). Only if that succeeds is the
> action of stealing succeeding. 

If you're going to wait for writeback I don't really see the advantage
of stealing over simply allocating a new page.


