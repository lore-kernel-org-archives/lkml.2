Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0JUQWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:22:22 -0400
Received: from mail.openrapids.net ([64.15.138.104]:57619 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753224Ab0JUQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:22:20 -0400
Date: Thu, 21 Oct 2010 12:22:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Message-ID: <20101021162215.GA8463@Krystal>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net> <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com> <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net> <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net> <20101021084838.GA1590@arch.trippelsdorf.de> <1287651165.9021.38.camel@marge.simson.net> <20101021115723.GA1587@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021115723.GA1587@arch.trippelsdorf.de>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:16:28 up 28 days, 20:18,  4 users,  load average: 0.31, 0.27,
	0.20
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Markus Trippelsdorf (markus@trippelsdorf.de) wrote:
> On Thu, Oct 21, 2010 at 10:52:45AM +0200, Mike Galbraith wrote:
> > On Thu, 2010-10-21 at 10:48 +0200, Markus Trippelsdorf wrote:
> > > On Thu, Oct 21, 2010 at 10:11:55AM +0200, Mike Galbraith wrote:
> > > > On Wed, 2010-10-20 at 04:56 +0200, Ingo Molnar wrote:
> > > > 
> > > > > Mind doing more of the tty->desktop renames/generalizations as Linus suggested, and 
> > > > > resend the patch?
> > > > 
> > > > Here she comes.  Better/Worse?
> > > > 
> > > > Changes:
> > > > - tty->autogroup.
> > > > - only autogroup fair class tasks.
> > > > - removed dainbramaged sleeper vruntime twiddling.
> > > > - removed paranoid locking.
> > > > - removed noop detatch code.
> > > > 
> > > > > I'd also suggest to move it out of EXPERIMENTAL - we dont really do that for core 
> > > > > kernel features as most distros enable CONFIG_EXPERIMENTAL so it's a rather 
> > > > > meaningless distinction. Since the feature is default-n, people will get the old 
> > > > > scheduler by default but can also choose this desktop-centric scheduling mode.
> > > > > 
> > > > > I'd even argue to make it default-y, because this patch clearly cures a form of 
> > > > > kbuild cancer.
> > > > 
> > > > You top dogs can make the default call.. it it's accepted that is ;-)
> > > > 
> > > > Marcus:  care to try the below?  Works fine for me (but so did first
> > > > cut).  It depends on the attached patch, and applied to virgin shiny new
> > > > 2.6.36.
> > > 
> > > Works fine interactively, but I still get the same kernel BUG on reboot
> > > time as before. Would a photo of the trace help you?
> > 
> > Odd.  Yeah, please send me the photo and your .config.
> 
> OK here you go. Both are attached.

In the backtrace, the scheduler is called from:

do_group_exit()
  __dequeue_signal()
    do_exit()

given that task_group() is called from many spots in the scheduler, I wonder if
some checks making sure that tg != NULL in task_group() would be appropriate ?
Also checking that p->signal is non-NULL in autogroup_attach_tty() might help.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
