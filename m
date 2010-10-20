Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0JTQop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 12:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0JTQoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 12:44:44 -0400
Date: Wed, 20 Oct 2010 12:43:24 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
	trace_sched_wakeup.c
Message-ID: <20101020164324.GC7348@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020154045.GA18353@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 05:40:45PM +0200, Ingo Molnar wrote:
> FYI, there's a new mystery hang (sometimes crash) that triggers in -tip - and which 
> seems to be tracing related. See the crashlog below - config attached.
> 
> It's not bisectable - small changes in the kernel make the bug come/go. (might be a 
> race of some sorts)
> 
> Thanks,
> 
> 	Ingo
> 

strange b/c it looks like we get though enabling/disabling the
tracepoitns individually, but then when we go to enable all the
tracepoints we hit this hang - perhaps, suggesting a race. Do we always
fail after "Testing all events:" is printed? Does the crash have any
more clues. I will try and re-produce this.

Also, I noticed some recent changes to text_poke_smp() usage of
stop_machine() on Oct. 14th. That's related to the area where this appears
to hang, so if things were working with this .config before then, that
might be a place to look. Adding Masami to the 'cc list.

thanks,

-Jason
