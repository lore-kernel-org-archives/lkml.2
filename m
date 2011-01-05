Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab1AETub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 14:50:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357Ab1AETu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 14:50:28 -0500
MIME-Version: 1.0
In-Reply-To: <1294254867.2016.281.camel@laptop>
References: <20101224122338.172750730@chello.nl> <20101224123742.724459093@chello.nl>
 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
 <1294054362.2016.74.camel@laptop> <20110104064542.GF3402@amd> <1294254867.2016.281.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Jan 2011 11:43:12 -0800
Message-ID: <AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@kernel.dk>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 11:14 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> There appear to be only two callsites of said horror, one in the exit
> path and one in ata-eh, neither appear to be performance critical so I
> replaced them with a simple lock-unlock sequence.

Again, WHY?

What's the problem with the current code? Instead of generating ugly
patches to change it, and instead of removing it, just say what the
PROBLEM is.

Stop this wanking already. The exit path is certainly not unimportant.

And if you want to change the thing to be more efficient, I'm ok with
that, as long as it's done PRETTILY instead of making the damn thing
an unreadable mess.

The current "spin_unlock_wait()" is obvious. I'm perfectly happy
improving on it, but I would want to retain the "obvious" part, which
your previous patch certainly didn't do.

Some simple helper functions to extract the tail/head part of the
ticket lock to make the comparisons understandable, together with
always accessing the lock with the proper ACCESS_ONCE() would have
made your previous patch acceptable. But you ignored that feedback,
and instead you now want to do a "let's just remove it entirely patch"
that is even worse.

And in NEITHER version did you actually give any actual *REASON* for
the change in the first place.

Why? WHY?

                      Linus
