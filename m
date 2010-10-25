Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0JYP4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:56:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab0JYP4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:56:54 -0400
Date: Mon, 25 Oct 2010 11:55:42 -0400
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
Message-ID: <20101025155541.GA2884@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu> <20101020164324.GC7348@redhat.com> <20101020183329.GA12666@elte.hu> <20101021110925.GA27219@elte.hu> <20101022175845.GF6498@redhat.com> <20101022182433.GA24637@elte.hu> <20101022183900.GG6498@redhat.com> <20101023200216.GA19324@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023200216.GA19324@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 10:02:16PM +0200, Ingo Molnar wrote:
> 
> > > Not the same config, and it's very spurious - i.e. a slightly different -tip 
> > > version with the same config will boot fine. (this suggests some race)
> > 
> > if possible, can you post that .config?
> 
> I just reproduced it again with tip-1128a72 - config and full bootlog attached.
> 
> The crash picture tends to vary - sometimes it crashes in fork, sometimes in the 
> timer interrupt. Here's the current one:
> 

thanks. I've been able to re-produce both the fork, and the timer
interrupt crashes.

It looks to me like we are patching the correct addresses with the
correct instructions, based on looking at the disassembly and tracing
what is getting patched when before the crash.

That's not say we aren't missing a cache flush somewhere...but I don't see
any code in a bad state so far...

I'm also wondering if the self tests arent' enabled. If we run them
after the system is up, if that works. perhaps, during boot things
aren't quite set up right for some reason?

Another variable here is of course the compiler version. I know that
'asm goto' was backported to the fedora 4.4 gcc...but it would be
interesting to test a 4.5 version in the failure cases - I will look at
that shortly.

thanks,

-Jason
