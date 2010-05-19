Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0ESPDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:03:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab0ESPDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:03:17 -0400
Date: Wed, 19 May 2010 07:59:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Nick Piggin <npiggin@suse.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: Unexpected splice "always copy" behavior observed
In-Reply-To: <1274280968.26328.774.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org>
References: <20100518153440.GB7748@Krystal>  <1274197993.26328.755.camel@gandalf.stny.rr.com>  <1274199039.26328.758.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org>  <20100519063116.GR2516@laptop> 
 <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org> <1274280968.26328.774.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, Steven Rostedt wrote:

> On Wed, 2010-05-19 at 07:39 -0700, Linus Torvalds wrote:
> 
> > The real limitation is likely always going to be the fact that it has to 
> > be page-aligned and a full page. For a lot of splice inputs, that simply 
> > won't be the case, and you'll end up copying for alignment reasons anyway.
> 
> That's understandable. For the use cases of splice I use, I work to make
> it page aligned and full pages. Anyone else using splice for
> optimizations, should do the same. It only makes sense.
> 
> The end of buffer may not be a full page, but then it's the end anyway,
> and I'm not as interested in the speed.

Btw, since you apparently have a real case - is the "splice to file" 
always just an append? IOW, if I'm not right in assuming that the only 
sane thing people would reasonable care about is "append to a file", then 
holler now.

		Linus
