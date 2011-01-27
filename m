Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1A0RED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:04:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34871 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1A0REB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:04:01 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=AlKY2pELOfUA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JzQDSukh4RELGp8dWaAA:9 a=Vm3sh0vCT14NhGNoCCWUFY3bfXgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 8/20]  8: uprobes: mmap and fork
 hooks.
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20110126090643.GI19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095848.23751.73144.sendpatchset@localhost6.localdomain6>
	 <1295957741.28776.719.camel@laptop>
	 <1295985926.10144.61.camel@gandalf.stny.rr.com>
	 <20110126090643.GI19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 27 Jan 2011 12:03:57 -0500
Message-ID: <1296147837.10144.79.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 14:36 +0530, Srikar Dronamraju wrote:

> > Not to mention that p is uninitialized. Did this code ever work?
> 
> I think the original patch that I sent had p initialized. I think it got
> dropped off by Peter when he replied. Please do confirm.


> +static void search_within_subtree(struct rb_node *n, struct inode *inode,
> +               struct list_head *tmp_list)
> +{
> +       struct rb_node *p;
> +
> +       if (p)
> +               __search_within_subtree(p, inode, tmp_list);
> +
> +       p = n->rb_right;
> +       if (p)
> +               __search_within_subtree(p, inode, tmp_list);
> +}
> +
> 
The above is from the original patch. 'p' does not look initialized to
me.

-- Steve


