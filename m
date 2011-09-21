Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003Ab1IUERm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 00:17:42 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49438 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1IUERl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 00:17:41 -0400
Date: Wed, 21 Sep 2011 09:33:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 4/26]   uprobes: Define hooks for
 mmap/munmap.
Message-ID: <20110921040344.GD6568@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120040.25326.63549.sendpatchset@srdronam.in.ibm.com>
 <20110920170310.GB27959@stefanha-thinkpad.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110920170310.GB27959@stefanha-thinkpad.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stefan Hajnoczi <stefanha@linux.vnet.ibm.com> [2011-09-20 18:03:10]:

> On Tue, Sep 20, 2011 at 05:30:40PM +0530, Srikar Dronamraju wrote:
> > +static void build_probe_list(struct inode *inode, struct list_head *head)
> > +{
> > +	struct uprobe *uprobe;
> > +	struct rb_node *n;
> > +	unsigned long flags;
> > +
> > +	n = uprobes_tree.rb_node;
> > +	spin_lock_irqsave(&uprobes_treelock, flags);
> 
> Not sure whether grabbing root.rb_node outside the spinlock is safe?  If
> the tree is rotated on another CPU you could catch and out-of-date node?


Agree that its better to access the node in the spinlock.
Shall correct this.
 
> > +static void dec_mm_uprobes_count(struct vm_area_struct *vma,
> > +		struct inode *inode)
> > +{
> > +	struct uprobe *uprobe;
> > +	struct rb_node *n;
> > +	unsigned long flags;
> > +
> > +	n = uprobes_tree.rb_node;
> > +	spin_lock_irqsave(&uprobes_treelock, flags);
> 
> Same here.

Okay.

-- 
Thanks and Regards
Srikar
