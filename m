Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0F2R7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:59:11 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51570 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0F2R7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:59:08 -0400
Date: Tue, 29 Jun 2010 23:23:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv6 2.6.35-rc3-tip 10/12]  perf: Dont adjust symbols on
 name lookup
Message-ID: <20100629175342.GE23231@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
 <20100628055941.6869.59092.sendpatchset@localhost6.localdomain6>
 <20100628135038.GA8902@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100628135038.GA8902@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > perf: Dont adjust symbols on name lookup
> > 
> > Adjusting symbols is not needed if we are searching by name even
> > if the symbols correspond to user space objects.
> > Infact if we adjust and search symbols by name, we get incorrect
> > results.
> 
> I'll review this, but it would be nice to explain why we get incorrect
> results, as we may be just fixing a symptom of some other problem.
> 

You are right. I removed this patch and still see no change in
behaviour. Earlier without this patch, I saw that perf report
would show a wrong function name(around 2.6.34-rc5 and I carried it
to 2.6.35-tip). However the number of events recorded would
correspond to the probed function. 

Since I am seeing correct behaviour even without this patch, I
will drop this patch in the next posting of the patchset.

--
Thanks
Srikar
