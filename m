Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab1FIFuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:50:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47234 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1FIFui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:50:38 -0400
Date: Thu, 9 Jun 2011 11:13:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Wilson <wilsons@start.ca>
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
Subject: Re: [PATCH v4 3.0-rc2-tip 4/22]  4: Uprobes: register/unregister
 probes.
Message-ID: <20110609054304.GC6123@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607125900.28590.16071.sendpatchset@localhost6.localdomain6>
 <20110608221032.GA9965@wicker.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110608221032.GA9965@wicker.gateway.2wire.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +		mm = vma->vm_mm;
> > +		if (!valid_vma(vma)) {
> > +			mmput(mm);
> > +			continue;
> > +		}
> > +
> > +		vaddr = vma->vm_start + offset;
> > +		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> > +		if (vaddr < vma->vm_start || vaddr > vma->vm_end) {
> 
> This check looks like it is off by one?  vma->vm_end is already one byte
> past the last valid address in the vma, so we should compare using ">="
> here I think.

Right, we are off-by one.
Will correct in the next patchset. 
Will also correct the other places where we check for vm_end.

> > +
> > +	if (!del_consumer(uprobe, consumer)) {
> > +		pr_debug("No uprobe found with consumer %p\n",
> > +				consumer);
> > +		return;
> > +	}
> 
> When del_consumer() fails dont we still need to do a put_uprobe(uprobe)
> to drop the extra access ref?
> 

Yes, we need to check and drop the reference.
Will correct in the next patchset. 

> > +
> > +	INIT_LIST_HEAD(&tmp_list);
> > +
> > +	mapping = inode->i_mapping;

-- 
Thanks and Regards
Srikar
