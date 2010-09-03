Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0ICRZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 13:25:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:49907 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab0ICRZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 13:25:54 -0400
Subject: Re: [PATCHv11 2.6.36-rc2-tip 3/15]  3: uprobes: Slot allocation
 for Execution out of line(XOL)
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100903164010.GA1904@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
	 <20100825134156.5447.43216.sendpatchset@localhost6.localdomain6>
	 <1283372009.2059.1557.camel@laptop>
	 <20100903164010.GA1904@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Sep 2010 19:25:18 +0200
Message-ID: <1283534718.2050.305.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 22:10 +0530, Srikar Dronamraju wrote:
> > > +   vma = find_vma(mm, addr);
> > > +
> > > +   /* Don't expand vma on mremap(). */
> > > +   vma->vm_flags |= VM_DONTEXPAND | VM_DONTCOPY;
> > > +   area->vaddr = vma->vm_start;
> > 
> > Seems interesting,.. why not use install_special_mapping(), that's what
> > the VDSO uses.
> 
> Okay, I hadnt looked at install_special_mapping earlier so I will take a
> look and incorporate it. However I am not clear at this point what
> install_special_mapping is giving us here.  Also install_special_mapping
> is already defining its own vm_ops esp a close method thats doesnt seem
> to be doing anything. So at this point I am not clear how we are link
> the vm_ops, the close method and install_special_mapping.

What you're doing might well be the right thing, I was just wondering.

I think that, after thinking about it more, that the shmem file thing
you're doing has the added benefit that the things gets auto-magic
paging, which is a good thing.


