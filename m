Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2AFLPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:15:50 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47032 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758477Ab2AFLPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:15:49 -0500
Date: Fri, 6 Jan 2012 16:38:24 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v8 3.2.0-rc5 1/9] uprobes: Install and remove
 breakpoints.
Message-ID: <20120106110824.GD14946@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com>
 <20111216122808.2085.76986.sendpatchset@srdronam.in.ibm.com>
 <1325695788.2697.3.camel@twins>
 <20120106061407.GC14946@linux.vnet.ibm.com>
 <1325847461.2442.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1325847461.2442.4.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12010611-6078-0000-0000-0000066B0F88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-01-06 11:57:41]:

> On Fri, 2012-01-06 at 11:44 +0530, Srikar Dronamraju wrote:
> >         - consumers for the uprobe is NULL, so mmap_uprobe will not
> >           insert new breakpoints which correspond to this uprobe until
> >           or unless another consumer gets added for the same probe.
> > 
> >         - If a new consumer gets added for this probe, we reuse the
> >           uprobe struct.
> 
> Ok, and when we install a new 'first' consumer we'll again try and
> install all breakpoints ignoring those that were already there?
> 

Yes, We install breakpoints as if its the first time a probe has been
requested to be installed, including setting the UPROBES_RUN_HANDLER
flag.

We do check if existing breakpoints are around during the actual
insertion, in which case install_breakpoint() will return -EEXIST.
However register assumes EEXIST to be non-fatal, and continues as if its
successful.

-- 
Thanks and Regards
Srikar

