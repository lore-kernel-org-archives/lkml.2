Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1AYUFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:05:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab1AYUFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:05:31 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=AlKY2pELOfUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ldri11vcZ50esFR7OKkA:9 a=ddZJZnm9R6rNs8lHnVRM5LUvlGsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@vger.kernel.org>,
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
In-Reply-To: <1295957741.28776.719.camel@laptop>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
	 <1295957741.28776.719.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 25 Jan 2011 15:05:26 -0500
Message-ID: <1295985926.10144.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 13:15 +0100, Peter Zijlstra wrote:
> On Thu, 2010-12-16 at 15:28 +0530, Srikar Dronamraju wrote:

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
> 
> Whee recursion FTW!, you just blew your kernel stack :-)
> 
> Since you sort inode first, offset second, I think you can simply look
> for the first matching inode entry and simply rb_next() until you don't
> match.

Not to mention that p is uninitialized. Did this code ever work?

-- Steve


