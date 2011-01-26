Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1AZKLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:11:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56489 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1AZKLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:11:24 -0500
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes:
 register/unregister probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20110126075558.GB19725@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
	 <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
	 <1295957744.28776.722.camel@laptop>
	 <20110126075558.GB19725@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 11:11:48 +0100
Message-ID: <1296036708.28776.1138.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 13:25 +0530, Srikar Dronamraju wrote:
> 
> > > +
> > > +               list_add(&mm->uprobes_list, &tmp_list);
> > > +               mm->uprobes_vaddr = vma->vm_start + offset;
> > > +       }
> > > +       spin_unlock(&mapping->i_mmap_lock);
> > 
> > Both this and unregister are racy, what is to say:
> >  - the vma didn't get removed from the mm
> >  - no new matching vma got added
> > 
> 
> register_uprobe, unregister_uprobe, uprobe_mmap are all synchronized by
> uprobes_mutex. So I dont see one unregister_uprobe getting thro when
> another register_uprobe is working with a vma.
> 
> If I am missing something elementary, please explain a bit more.

afaict you're not holding the mmap_sem, so userspace can simply unmap
the vma.
