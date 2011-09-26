Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab1IZQ1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:27:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34032 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1IZQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:27:32 -0400
Date: Mon, 26 Sep 2011 21:22:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
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
Subject: Re: [PATCH v5 3.1.0-rc4-tip 13/26] x86: define a x86 specific
 exception notifier.
Message-ID: <20110926155252.GA8087@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120238.25326.71868.sendpatchset@srdronam.in.ibm.com>
 <1317046791.1763.26.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317046791.1763.26.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-09-26 16:19:51]:

> On Tue, 2011-09-20 at 17:32 +0530, Srikar Dronamraju wrote:
> > @@ -820,6 +821,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
> >                 mce_notify_process();
> >  #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
> >  
> > +       if (thread_info_flags & _TIF_UPROBE) {
> > +               clear_thread_flag(TIF_UPROBE);
> > +#ifdef CONFIG_X86_32
> > +               /*
> > +                * On x86_32, do_notify_resume() gets called with
> > +                * interrupts disabled. Hence enable interrupts if they
> > +                * are still disabled.
> > +                */
> > +               local_irq_enable();
> > +#endif
> > +               uprobe_notify_resume(regs);
> > +       }
> > +
> >         /* deal with pending signal delivery */
> >         if (thread_info_flags & _TIF_SIGPENDING)
> >                 do_signal(regs); 
> 
> It would be good to remove this difference between i386 and x86_64.


I think, we have already discussed this. I tried getting to know why we
have this difference in behaviour. However I havent been able to find
the answer.

If you can get somebody to answer this, I would be happy to modify as
required.

-- 
Thanks and Regards
Srikar
