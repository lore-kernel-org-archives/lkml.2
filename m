Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AFS1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:27:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:55667 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab1AFS1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:27:15 -0500
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <20110106103841.GA3493@amd>
References: <20101224122338.172750730@chello.nl>
	 <20101224123742.724459093@chello.nl>
	 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
	 <1294054362.2016.74.camel@laptop> <20110104064542.GF3402@amd>
	 <1294254867.2016.281.camel@laptop>
	 <AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
	 <1294306353.2016.304.camel@laptop>  <20110106103841.GA3493@amd>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Jan 2011 19:26:35 +0100
Message-ID: <1294338395.2016.381.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 21:38 +1100, Nick Piggin wrote:
> I can't see how the usage in libata could be right. If we're waiting
> for some modifications inside the critical section, then it seems we
> could load some shared data before the lock is actually released, on
> an architecture which does load/load reordering. At best it needs some
> good comments and perhaps a barrier or two.
> 
> The spin_unlock_wait in do_exit seems like it shouldn't be needed --
> exit_pi_state_list takes the pi_lock after the task has died anyway,
> so I can't see what the problem would be. Removing the call (and
> perhaps put a BUG_ON(!(curr->flags & PF_EXITING)) in exit_pi_state_list
> would do the same thing, avoid the barrier, and localize fuxtex exit
> protocol to futex.c. 

Jeff, Tejun, could you look at the ata-eh thing, then I'll put sorting
through the futex thing on my todo list.
