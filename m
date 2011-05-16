Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1EPNEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:04:00 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:50404 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751740Ab1EPND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:03:59 -0400
Date: Mon, 16 May 2011 15:03:39 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516130339.GA12539@host1.jankratochvil.net>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
 <20110516122642.GD10469@host1.jankratochvil.net>
 <20110516124259.GU23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516124259.GU23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 14:42:59 +0200, Tejun Heo wrote:
> I still don't understand why you need to know the order beforehand.
> Wouldn't pending list be enough?  What are you trying to achieve?

If you check the GDB debugging session transcript I gave GDB stopped in
a moment when all the threads already returned from tkill()s sending SIGUSR1s
and SIGUSR2.

All threads are stopped, user is investigating the situation.  And GDB tells
the user (only) SIGUSR1 was delivered.  The user has no chance to find out
SIGUSR2 is already pending / to be delivered.  This is one of the many reasons
why debugging various racy cases is a nightmare.

I was trying to suggest some ways how to give user the complete overview of
the debuggee situation - where both SIGUSR1 and SIGUSR2 would be reported on
the first stop.

You are right GDB could examine SigCgt, SigBlk (not sure if others) and report
those signals.  Maybe it is right that way and we can forget about it.


There is (was) a larger problem of signals reordering which I fixed in
	[patch 3/4]#3 linux-nat: Do not respawn signals
	http://sourceware.org/ml/gdb-patches/2010-09/msg00360.html
but that mess you should have fixed by PTRACE_INTERRUPT which no longer
interacts with signals.  But it gave me the idea of another situation above
where the debugger may want to know all the currently pending signals at once.



Thanks,
Jan
