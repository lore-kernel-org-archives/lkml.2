Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0DRW7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 18:59:11 -0400
Received: from mail.openrapids.net ([64.15.138.104]:35468 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752546Ab0DRW7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 18:59:09 -0400
Date: Sun, 18 Apr 2010 18:59:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jarkko Nikula <jhnikula@gmail.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC patch] CFS fix place entity spread issue (v2)
Message-ID: <20100418225906.GA14337@Krystal>
References: <20100418131302.GA3614@Krystal> <alpine.LFD.2.00.1004181317100.14500@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004181317100.14500@i5.linux-foundation.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:49:04 up 86 days,  1:26,  2 users,  load average: 0.00, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Sun, 18 Apr 2010, Mathieu Desnoyers wrote:
> >
> > CFS fix place entity spread issue (v2)
> > 
> > Huge CFS vruntime spread (18 minutes) has been observed with LTTng while simply
> > running Xorg on a uniprocessor machine. Detailed explanation in my ELC2010
> > presentation at:
> 
> Hmm. I tested this patch with my favourite non-scientific desktop load 
> test: do web browsing while doing a kernel compile with "make -j16" (after 
> doing a "git clean -dqfx" and "ccache -C" to get rid of old object files 
> and ccache).
> 
> This is on a dual-core (with SMT, so 4 threads) Core i5, so "make -j16" 
> overcommits the CPU's quite a bit.
> 
> And quite frankly, I think your patch makes things much worse. I don't 
> have numbers, but it felt much choppier and slower to do scrolling in 
> firefox o moving windows around while the load average is 20+.
> 
> My testload is in no way objective, nor necessarily any good, but it's the 
> one I happen to use, and while it's subjective, I think the difference was 
> pretty clear and not good.
> 
> 			Linus

Degradation of this particular workload is expected, because the nature of the
large CFS spread issue favors Xorg: it gets litterally minutes of available
vruntime, while most other threads (e.g. kernel build, audio playing, etc..)
suffer from this.

I'll try to play a bit with this (I got plenty of time to kill at the airport
today, missed my connecting flight back from San Francisco). Ideally, we might
want to try to find a way to ensure that place_entity() is kind to sleepers, but
without putting them before min_vruntime. I don't have any SMP machine with Xorg
handy, but I'll try to push my UP laptop a bit more heavily with a kernel build.

If we are lucky enough, we might just have to twist a knob or two to make Xorg
more responsive.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
