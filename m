Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab0ESPvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:51:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50080 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753178Ab0ESPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:51:39 -0400
Date: Wed, 19 May 2010 11:51:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100519155136.GA2039@Krystal>
References: <20100518153440.GB7748@Krystal> <1274197993.26328.755.camel@gandalf.stny.rr.com> <1274199039.26328.758.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org> <20100519063116.GR2516@laptop> <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org> <1274280968.26328.774.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1005190758070.23538@i5.linux-foundation.org> <1274281956.26328.776.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274281956.26328.776.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:50:17 up 116 days, 18:27,  9 users,  load average: 0.47, 0.28,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2010-05-19 at 07:59 -0700, Linus Torvalds wrote:
> > 
> 
> > Btw, since you apparently have a real case - is the "splice to file" 
> > always just an append? IOW, if I'm not right in assuming that the only 
> > sane thing people would reasonable care about is "append to a file", then 
> > holler now.
> 
> My use case is just to move the data from the ring buffer into a file
> (or network) as fast as possible. It creates a new file and all
> additions are "append to a file".
> 
> I believe Mathieu does the same.
> 
> With me, you are correct.

Same here. My ring buffer only ever use splice() to append at the end of a file
or to the network, and always outputs data in multiples of the page size.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
