Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1CNRib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:38:31 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33646 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab1CNRia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:38:30 -0400
Date: Mon, 14 Mar 2011 23:02:38 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 5/20]  5: Uprobes:
 register/unregister probes.
Message-ID: <20110314173238.GR24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133454.27435.81020.sendpatchset@localhost6.localdomain6>
 <1300118433.9910.118.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300118433.9910.118.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-03-14 12:00:33]:

> On Mon, 2011-03-14 at 19:04 +0530, Srikar Dronamraju wrote:
> > +/* Returns 0 if it can install one probe */
> > +int register_uprobe(struct inode *inode, loff_t offset,
> > +                               struct uprobe_consumer *consumer)
> > +{
> > +       struct prio_tree_iter iter;
> > +       struct list_head tmp_list;
> > +       struct address_space *mapping;
> > +       struct mm_struct *mm, *tmpmm;
> > +       struct vm_area_struct *vma;
> > +       struct uprobe *uprobe;
> > +       int ret = -1;
> > +
> > +       if (!inode || !consumer || consumer->next)
> > +               return -EINVAL;
> > +       uprobe = uprobes_add(inode, offset);
> 
> What happens if uprobes_add() returns NULL?
> 
Right again, I should have added a check to see if uprobes_add
hasnt returned NULL.

-- 
Thanks and Regards
Srikar
