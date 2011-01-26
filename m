Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1AZIv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 03:51:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52208 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab1AZIv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 03:51:58 -0500
Date: Wed, 26 Jan 2011 14:15:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and
 remove a uprobe in a rb tree.
Message-ID: <20110126084522.GF19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
 <1295963773.28776.1054.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295963773.28776.1054.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-25 14:56:13]:

> On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> > +struct uprobe_consumer {
> > +       int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
> > +       /*
> > +        * filter is optional; If a filter exists, handler is run
> > +        * if and only if filter returns true.
> > +        */
> > +       bool (*filter)(struct uprobe_consumer *self, struct task_struct *task);
> > +
> > +       struct uprobe_consumer *next;
> > +       void *fvalue;   /* filter value */
> > +}; 
> 
> Since you pass in a pointer to this structure at register_uprobe() its
> user allocated, hence you can remove the fvalue thing and let the user
> embed this in a larger struct if needed, the filter functions can then
> use container_of() to get at the larger data structure.


Okay, Will do, but Is there a reason for moving the fvalue out of the
uprobe_consumer? Except for reducing the size of the structure, I am
unable to see advantage.
