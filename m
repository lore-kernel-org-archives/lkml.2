Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1FIF5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:57:23 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51890 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1FIF5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:57:22 -0400
Date: Thu, 9 Jun 2011 11:20:15 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH v4 3.0-rc2-tip 7/22]  7: uprobes: mmap and fork hooks.
Message-ID: <20110609055015.GE6123@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125931.28590.12362.sendpatchset@localhost6.localdomain6>
 <20110608221255.GC9965@wicker.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110608221255.GC9965@wicker.gateway.2wire.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static void add_to_temp_list(struct vm_area_struct *vma, struct inode *inode,
> > +		struct list_head *tmp_list)
> > +{
> > +	struct uprobe *uprobe;
> > +	struct rb_node *n;
> > +	unsigned long flags;
> > +
> > +	n = uprobes_tree.rb_node;
> > +	spin_lock_irqsave(&uprobes_treelock, flags);
> > +	uprobe = __find_uprobe(inode, 0, &n);
> 
> It is valid for a uprobe offset to be zero I guess, so perhaps we need
> to do a put_uprobe() here when the result of __find_uprobe() is
> non-null.

Right, will check for the result of __find_uprobe and do a put_uprobe().
Will correct this in the next patchset.

-- 
Thanks and Regards
Srikar
