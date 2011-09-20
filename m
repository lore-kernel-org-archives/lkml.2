Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab1ITR5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:57:25 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:56236 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1ITR5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:57:24 -0400
Date: Tue, 20 Sep 2011 18:03:10 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20110920170310.GB27959@stefanha-thinkpad.localdomain>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120040.25326.63549.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920120040.25326.63549.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 05:30:40PM +0530, Srikar Dronamraju wrote:
> +static void build_probe_list(struct inode *inode, struct list_head *head)
> +{
> +	struct uprobe *uprobe;
> +	struct rb_node *n;
> +	unsigned long flags;
> +
> +	n = uprobes_tree.rb_node;
> +	spin_lock_irqsave(&uprobes_treelock, flags);

Not sure whether grabbing root.rb_node outside the spinlock is safe?  If
the tree is rotated on another CPU you could catch and out-of-date node?

> +static void dec_mm_uprobes_count(struct vm_area_struct *vma,
> +		struct inode *inode)
> +{
> +	struct uprobe *uprobe;
> +	struct rb_node *n;
> +	unsigned long flags;
> +
> +	n = uprobes_tree.rb_node;
> +	spin_lock_irqsave(&uprobes_treelock, flags);

Same here.

Stefan
