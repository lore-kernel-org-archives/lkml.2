Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1AZJNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:13:20 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56443 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab1AZJNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:13:18 -0500
Date: Wed, 26 Jan 2011 14:36:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
Message-ID: <20110126090643.GI19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
 <1295957741.28776.719.camel@laptop>
 <1295985926.10144.61.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1295985926.10144.61.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-01-25 15:05:26]:

> On Tue, 2011-01-25 at 13:15 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:
> 
> > > +static void search_within_subtree(struct rb_node *n, struct inode *inode,
> > > +               struct list_head *tmp_list)
> > > +{
> > > +       struct rb_node *p;
> > > +
> > > +       if (p)
> > > +               __search_within_subtree(p, inode, tmp_list);
> > > +
> > > +       p = n->rb_right;
> > > +       if (p)
> > > +               __search_within_subtree(p, inode, tmp_list);
> > > +} 
> > 
> > Whee recursion FTW!, you just blew your kernel stack :-)
> > 
> > Since you sort inode first, offset second, I think you can simply look
> > for the first matching inode entry and simply rb_next() until you don't
> > match.
> 
> Not to mention that p is uninitialized. Did this code ever work?

I think the original patch that I sent had p initialized. I think it got
dropped off by Peter when he replied. Please do confirm.


-- 
Thanks and Regards
Srikar
