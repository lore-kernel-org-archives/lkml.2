Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab1LWQQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 11:16:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab1LWQQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 11:16:43 -0500
Date: Fri, 23 Dec 2011 17:16:37 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Anders Johansson <ajohansson@novell.com>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: possible ERESTARTNOHAND leak into userspace
Message-ID: <20111223161637.GD26157@tiehlicka.suse.cz>
References: <20111223131139.GA26157@tiehlicka.suse.cz>
 <20111223150227.GA27059@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223150227.GA27059@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23-12-11 16:02:27, Oleg Nesterov wrote:
> On 12/23, Michal Hocko wrote:
> >
> > Hi,
> > this has already been discussed few years back with reports that select
> > returned with ERESTARTNOHAND in multi-threaded applications
> > (http://forum.soft32.com/linux/PATCH-select-fix-sys_select-leak-ERESTARTNOHAND-userspace-ftopict338572.html)
> >
> > Dave has come up with a possible explanation of the race but there was
> > no further follow up with a conclusion.
> >
> > Just for reference:
> >         Thread_A				Thread_B
> > 	CPU0					CPU1
> > 						syscall_XYZ
> > core_sys_select
> >   ret = -ERESTARTNOHAND;
> >   if (signal_pending(current))
> >      					do_notify_resume
> >      					  do_signal (clear signal pending)
> 
> "clear signal pending" can't affect Thread_A. Even if it steals
> the signal sent to Thread_A.

Ah, I have totally missed that signal_pending is thread local.

[...]
> > The race window is rather small and hard to trigger but we have seen
> > reports where people really saw select returning ERESTARTNOHAND (on
> > 2.6.16 based kernel - x86_64).
> > I am not able to reproduce that myself neither with .16 kernel nor with
> > the current vanilla so I am not sure whether the problem has been fixed
> > already. But I do not see what prevents the race with vanilla.
> 
> I hope the problem was already fixed, at least I do not see anything
> wrong in core_sys_select().

And core_sys_select is basically same in 2.6.16 som I am still wondering
how we could leak the value.

Anyway this seems to be a .16 specific issue, sorry about the noise.

> 
> Oleg.
> 

Thanks a lot for the response.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
