Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985Ab0KSACJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 19:02:09 -0500
Received: from solo.fdn.fr ([80.67.169.19]:43379 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760826Ab0KSACH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 19:02:07 -0500
Date: Fri, 19 Nov 2010 01:02:04 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101119000204.GE6024@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>, Hans-Peter Jansen <hpj@urpla.net>,
	linux-kernel@vger.kernel.org,
	Lennart Poettering <mzxreary@0pointer.de>, david@lang.hm,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de> <201011182333.48281.hpj@urpla.net> <20101118231218.GX6024@const.famille.thibault.fr> <1290123351.18039.49.camel@maggy.simson.net> <20101118234339.GA6024@const.famille.thibault.fr> <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimTNxLYGLgnS9TUT_YiMnmDVrqseByGGogj+A4Z@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds, le Thu 18 Nov 2010 15:51:35 -0800, a écrit :
> On Thu, Nov 18, 2010 at 3:43 PM, Samuel Thibault
> <samuel.thibault@ens-lyon.org> wrote:
> >
> > What overhead? The implementation of cgroups is actually already
> > hierarchical.
> 
> Well, at least the actual group creation overhead.
> 
> If it's a "only at setsid()", that's a fairly rare thing (although I
> think somebody might want to run something like the AIM7 benchmark - I
> have this memory of it doing lots of tty tests).
> 
> Or if it's only at "user launches new program from window manager",
> that's rare too.
> 
> But if you do it per process group, now you're doing one for each
> command invocation in a shell, for example.

Well, if it's from an interactive shell, it's not really a problem :)

But when it's from a script it can become one, yes. But are cgroups so
expensive?

> If you're doing things per thread, you've already lost.

Not per thread, per process, i.e. put threads of the same process in the
same cgroup. Again, I would have thought that creating a cgroup is very
lightweight in front of a fork(). If not, maybe we are just looking for
another, more lightweight container information that the scheduler would
use [1], and keep more heavyweight containers for the non-automatic
creation way.

> Also, remember the goal: it was never about some theoretical end
> result. It's all about a simple heuristic that makes things work
> better. Trying to do that "perfectly" totally and utterly misses the
> whole point.

Sure.  Using sid should already be quite good, but including the uid
information as well should be easily even better.

Samuel

[1] Actually, I happen to have written a PhD thesis on this, that's why
I'm popping up:)
