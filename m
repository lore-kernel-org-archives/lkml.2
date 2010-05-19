Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0ESRiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:38:16 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34977 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0ESRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:38:14 -0400
Date: Wed, 19 May 2010 23:08:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/13] Uprobes v4
Message-ID: <20100519173806.GA3319@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
 <20100518204944.GA6959@Krystal>
 <20100519060803.GB19957@linux.vnet.ibm.com>
 <1274278660.5605.11006.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1274278660.5605.11006.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-05-19 16:17:40]:

> On Wed, 2010-05-19 at 11:38 +0530, Srikar Dronamraju wrote:
> > 
> > Also when uprobes implements global tracing support (i.e probing a
> > particular symbol in a dso across processes), it has to rely on
> > background page replacement. 
> 
> Uhm, how so?

For global tracing we cant use access_process_vm. The equivalent to
access_process_vm for global tracing would be to use copy_to_user.

However I am sure people wouldnt be happy using copy_to_user on a page
that other processes could have mapped. 

So that leaves us with background page replacement method. 
I do agree that we will not be using the same routine. But the technique
should be something similar(or do you disagree?). 

Or do you suggest any alternative methods for global tracing?

--
Thanks and Regards
Srikar
