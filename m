Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0JVDng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:43:36 -0400
Received: from ozlabs.org ([203.10.76.45]:43551 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab0JVDnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:43:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2][GIT PULL] tracing: Prevent unloadable modules from using trace_bprintk()
Date: Fri, 22 Oct 2010 14:13:28 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <1287668742.16971.585.camel@gandalf.stny.rr.com> <201010220805.14454.rusty@rustcorp.com.au> <1287700463.16971.603.camel@gandalf.stny.rr.com>
In-Reply-To: <1287700463.16971.603.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221413.28588.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 09:04:23 am Steven Rostedt wrote:
> On Fri, 2010-10-22 at 08:05 +1030, Rusty Russell wrote:
> > On Fri, 22 Oct 2010 12:15:42 am Steven Rostedt wrote:
> > > 
> > > Ingo,
> > > 
> > > This is based off of my core-2 branch. I'm moved this patch after that
> > > so if anyone has any objections, I can change this patch without holding
> > > off the previous one.
> > 
> > I think disabling use in modules is lazy,
> 
> and safer.

Well then just delete trace_bprintk altogether.  Even safer!

> > Can't you detect this on module unload and fix it up?  Or delay freeing the
> > module until the trace ring is emptied?
> 
> One possibility is to magically make all string formats used in
> trace_printk into its own section, and keep it allocated until the ring
> buffer is empty. Or, we can just do that with the module's entire string
> section, since we know whether or not that module has a trace_printk in
> it or not.

Exactly.  Set a flag in the module if it resolves trace_printk, and defer freeing
the module in that case.  This shouldn't be that hard...

Rusty.
