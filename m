Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab1IZMOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:14:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59000 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab1IZMOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:14:36 -0400
Date: Mon, 26 Sep 2011 17:29:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 1/26]   uprobes: Auxillary routines to
 insert, find, delete uprobes
Message-ID: <20110926115919.GB4072@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920115949.25326.2469.sendpatchset@srdronam.in.ibm.com>
 <20110920154259.GA25610@stefanha-thinkpad.localdomain>
 <1317035918.9084.83.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317035918.9084.83.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-09-26 13:18:38]:

> On Tue, 2011-09-20 at 16:42 +0100, Stefan Hajnoczi wrote:
> > On Tue, Sep 20, 2011 at 05:29:49PM +0530, Srikar Dronamraju wrote:
> > > +static void delete_uprobe(struct uprobe *uprobe)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&uprobes_treelock, flags);
> > > +	rb_erase(&uprobe->rb_node, &uprobes_tree);
> > > +	spin_unlock_irqrestore(&uprobes_treelock, flags);
> > > +	put_uprobe(uprobe);
> > > +	iput(uprobe->inode);
> > 
> > Use-after-free when put_uprobe() kfrees() the uprobe?
> 
> I suspect the caller still has one, and this was the reference for being
> part of the tree. But yes, that could do with a comment.
> 

Yes, the caller has a reference, However I went ahead and changed the
order of the last two statements.

> The comment near atomic_set() in __insert_uprobe() isn't too clear
> either. /* get access + drop ref */, would naively seem +1 -1 = 0,
> instead of +1 +1 = 2.
> 

Okay, Have modified the comment to /* get access + creation ref */

-- 
Thanks and Regards
Srikar
