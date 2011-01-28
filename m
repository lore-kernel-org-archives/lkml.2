Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab1A1FAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 00:00:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:44436 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1A1FAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 00:00:44 -0500
Date: Fri, 28 Jan 2011 10:23:53 +0530
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
Message-ID: <20110128045353.GU19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
 <1295957741.28776.719.camel@laptop>
 <1295985926.10144.61.camel@gandalf.stny.rr.com>
 <20110126090643.GI19725@linux.vnet.ibm.com>
 <1296147837.10144.79.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296147837.10144.79.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-01-27 12:03:57]:

> On Wed, 2011-01-26 at 14:36 +0530, Srikar Dronamraju wrote:
> 
> > > Not to mention that p is uninitialized. Did this code ever work?
> > 
> > I think the original patch that I sent had p initialized. I think it got
> > dropped off by Peter when he replied. Please do confirm.
> 
> 
> > +static void search_within_subtree(struct rb_node *n, struct inode *inode,
> > +               struct list_head *tmp_list)
> > +{
> > +       struct rb_node *p;
> > +
> > +       if (p)
> > +               __search_within_subtree(p, inode, tmp_list);
> > +
> > +       p = n->rb_right;
> > +       if (p)
> > +               __search_within_subtree(p, inode, tmp_list);
> > +}
> > +
> > 
> The above is from the original patch. 'p' does not look initialized to
> me.
> 

> -- Steve
> 
> 

Here is the extract from the original patch at
https://lkml.org/lkml/2010/12/16/74 that I sent to LKML and I dont see
p being uninitialized. 

+
+static void search_within_subtree(struct rb_node *n, struct inode *inode,
+		struct list_head *tmp_list)
+{
+	struct rb_node *p;
+
+	p = n->rb_left;
+	if (p)
+		__search_within_subtree(p, inode, tmp_list);
+
+	p = n->rb_right;
+	if (p)
+		__search_within_subtree(p, inode, tmp_list);
+}
+

However I have already agreed to remove this recursion and replace it
with a rb_next() logic.

-- 
Thanks and Regards
Srikar
