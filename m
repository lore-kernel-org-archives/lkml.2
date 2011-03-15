Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab1COSNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:13:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48349 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab1COSNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:13:49 -0400
Date: Tue, 15 Mar 2011 23:37:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 3/20] 3: uprobes: Breakground page
 replacement.
Message-ID: <20110315180743.GD24254@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133433.27435.49566.sendpatchset@localhost6.localdomain6>
 <alpine.LFD.2.00.1103151206430.2787@localhost6.localdomain6>
 <20110315175048.GC24254@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1103151902020.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103151902020.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2011-03-15 19:03:44]:

> On Tue, 15 Mar 2011, Srikar Dronamraju wrote:
> 
> > * Thomas Gleixner <tglx@linutronix.de> [2011-03-15 14:22:09]:
> > 
> > > On Mon, 14 Mar 2011, Srikar Dronamraju wrote:
> > > > +/*
> > > > + * Called with tsk->mm->mmap_sem held (either for read or write and
> > > > + * with a reference to tsk->mm
> > > 
> > > Hmm, why is holding it for read sufficient?
> > 
> > We are not adding a new vma to the mm; but just replacing a page with
> > another after holding the locks for the pages. Existing routines
> > doing close to similar things like the
> > access_process_vm/get_user_pages seem to be taking the read_lock. Do
> > you see a resaon why readlock wouldnt suffice?
> 
> No, I just was confused by the comment. Probably should have asked why
> you want to call it write locked.

We no more call it write locked. So we can drop the reference to
write lock.
