Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab2CMSJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 14:09:00 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44421 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab2CMSI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 14:08:56 -0400
Date: Tue, 13 Mar 2012 23:35:36 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] uprobes/core: Handle breakpoint and singlestep
 exception.
Message-ID: <20120313180536.GB21727@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120313140303.17134.1401.sendpatchset@srdronam.in.ibm.com>
 <20120313140313.17134.52012.sendpatchset@srdronam.in.ibm.com>
 <20120313153524.GB12193@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120313153524.GB12193@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031318-7182-0000-0000-00000107567A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 26a7a67..36508b9 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -67,6 +67,7 @@
> >  #include <linux/oom.h>
> >  #include <linux/khugepaged.h>
> >  #include <linux/signalfd.h>
> > +#include <linux/uprobes.h>
> >  
> >  #include <asm/pgtable.h>
> >  #include <asm/pgalloc.h>
> > @@ -731,6 +732,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
> >  		exit_pi_state_list(tsk);
> >  #endif
> >  
> > +	uprobe_free_utask(tsk);
> > +
> >  	/* Get rid of any cached register state */
> >  	deactivate_mm(tsk, mm);
> >  
> > @@ -1322,6 +1325,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  	INIT_LIST_HEAD(&p->pi_state_list);
> >  	p->pi_state_cache = NULL;
> >  #endif
> > +#ifdef CONFIG_UPROBES
> > +	p->utask = NULL;
> > +	p->uprobe_srcu_id = -1;
> > +#endif
> >  	/*
> >  	 * sigaltstack should be cleared when sharing the same VM
> >  	 */
> 
> Hm, I suspect by looking at the first two hunks you can guess 
> how the third hunk should be done more cleanly?
> 

Resent just this patch after addressing this comment.

-- 
thanks and regards
Srikar

