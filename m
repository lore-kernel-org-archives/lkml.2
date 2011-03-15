Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab1COSEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 14:04:42 -0400
Received: from www.tglx.de ([62.245.132.106]:52486 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259Ab1COSEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 14:04:37 -0400
Date: Tue, 15 Mar 2011 19:03:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20110315175048.GC24254@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.1103151902020.2787@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133433.27435.49566.sendpatchset@localhost6.localdomain6> <alpine.LFD.2.00.1103151206430.2787@localhost6.localdomain6> <20110315175048.GC24254@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Srikar Dronamraju wrote:

> * Thomas Gleixner <tglx@linutronix.de> [2011-03-15 14:22:09]:
> 
> > On Mon, 14 Mar 2011, Srikar Dronamraju wrote:
> > > +/*
> > > + * Called with tsk->mm->mmap_sem held (either for read or write and
> > > + * with a reference to tsk->mm
> > 
> > Hmm, why is holding it for read sufficient?
> 
> We are not adding a new vma to the mm; but just replacing a page with
> another after holding the locks for the pages. Existing routines
> doing close to similar things like the
> access_process_vm/get_user_pages seem to be taking the read_lock. Do
> you see a resaon why readlock wouldnt suffice?

No, I just was confused by the comment. Probably should have asked why
you want to call it write locked.
 
Thanks,

	tglx
