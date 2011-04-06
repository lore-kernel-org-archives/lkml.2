Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1DFUOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:14:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55314 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1DFUOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:14:46 -0400
Date: Wed, 6 Apr 2011 22:14:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/6] x86-64: Micro-optimize vclock_gettime
Message-ID: <20110406201442.GV21838@one.firstfloor.org>
References: <cover.1301324270.git.luto@mit.edu> <m2mxk35ji7.fsf@firstfloor.org> <BANLkTi=g96=Q_OOBeejcsZ1eWGZ9cZYLYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=g96=Q_OOBeejcsZ1eWGZ9cZYLYA@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 04:10:22PM -0400, Andrew Lutomirski wrote:
> I ran Ingo's time-warp-test w/ 6, 7, and 8 threads on Sandy Bridge and
> on a Xeon 5600 series chip.  My C2D laptop thinks that its TSC halts
> in idle and my only AMD system has unsynchronized TSCs.

I think you should have coverage on more systems. The original
problems that motivated the barriers were on older K8 AMD systems.

You can ask people on l-k to run such tests for you if you don't
have the hardware.

> > I did a similar attempt recently for the in kernel timers.
> > You won't see any difference in a micro benchmark loop, but you may
> > in a workload that dirties lots of cache between timer calls.
> 
> For CLOCK_REALTIME they're already in one cache line.  I tried the
> prefetch and couldn't measure a speedup even after playing with

Did you run a cache pig between the calls? With a tight loop it's obviously
useless.

> Agreed.  In fact, I could do both in one fell swoop: have a flag for
> the mode and have one option be "just issue the syscall."  Static
> branch stuff scares me because this stuff runs in userspace and, in
> theory, userspace might have COWed the page with this code in it.

The vdso is never cowed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
