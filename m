Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0FVGfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:35:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0FVGf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:35:29 -0400
Date: Tue, 22 Jun 2010 02:34:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 11/14] trace: uprobes trace_event interface
Message-ID: <20100622063428.GA15092@infradead.org>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614083008.29068.56731.sendpatchset@localhost6.localdomain6>
 <1277130156.9181.11.camel@gandalf.stny.rr.com>
 <20100622041529.GA25989@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622041529.GA25989@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 09:45:29AM +0530, Srikar Dronamraju wrote:
> As you see UPROBE_EVENT is gated on UPROBES. I think if UPROBES is
> enabled, then UPROBE_EVENT should be enabled. Esp with Christoph
> suggesting for module support to be removed, I think it becomes all the
> more reason for UPROBE_EVENT to be enabled by default. Otherwise there
> is no point in having uprobes code and having no enabled users.
> I was even looking at "select UPROBE_EVENT" on enabling UPROBES.
> 
> Do you have any specific reason why UPROBE_EVENT should not be enabled
> by default? 

default y generally is a big hammer.  But given that it depends on
UPROBES it might be fine here.  Then again the big question is why
we even bother with separate config options?  At least in this form
UPROBES just is supported for UPROBE_EVENT.  So it makes sense either
to remove the UPROBES option entirely, or at least make it invisible
to the user and let UPROBE_EVENT select it.

