Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750829Ab0FOEB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:01:59 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:48560 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0FOEB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:01:57 -0400
Date: Tue, 15 Jun 2010 09:30:01 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 2/14] mm: Move replace_page to mm/memory.c
Message-ID: <20100615040001.GD13800@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082818.29068.35191.sendpatchset@localhost6.localdomain6>
 <20100614174441.GC23754@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100614174441.GC23754@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 14, 2010 at 01:58:18PM +0530, Srikar Dronamraju wrote:
> > move_replace_page.patch
> > 
> > From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> > 
> > Move replace_page() and write_protect_page() to mm/memory.c
> > 
> > User bkpt will use background page replacement approach to insert/delete
> > breakpoints. Background page replacement approach will be based on
> > replace_page and write_protect_page.
> > Now replace_page() loses its static attribute.
> 
> Neither of these actually gets used in this series.  So you can drop
> the patch for now.
 
replace_page() and write_protect_page() are used in write_opcode() to
insert/remove a breakpoint in the user-space breakpoint insertion layer. 
i.e "[PATCH v5 3/14] User Space Breakpoint Assistance Layer"

Even if we merge uprobes and user_bkpt layers, we would still need
write_opcode function while inserting/deleting a breakpoint.

--
Thanks and Regards
Srikar
