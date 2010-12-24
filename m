Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab0LXNPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:15:44 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43654 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0LXNPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:15:43 -0500
Subject: Re: [RFC][PATCH 00/17] sched: Reduce runqueue lock contention -v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101224122338.172750730@chello.nl>
References: <20101224122338.172750730@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Dec 2010 14:15:41 +0100
Message-ID: <1293196541.29444.42.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 13:23 +0100, Peter Zijlstra wrote:
> This is the latest incarnation of my scary ttwu patch, its split up into
> tiny little pieces because at some point while working on the feedback from
> the last posting it all stopped working and tiny changes was the only way
> to find out wth I done wrong (I never did find out though, when I
> completely rewrote everything in tiny chunks it all magically worked again
> -- so I guess tglx is chuckling now).
> 
> Anyway, it still need a few more loose ends fixed, esp on 32bit there is
> the whole unlocked remote min_vruntime access where we can read partial
> updates and screw the timeline like problem. And I suppose there's a few
> more XXXs in there where I know things are needing TLC.
> 
> Also, I bet the eagle eyed lot Cc'ed will spot more holes, as all this is
> scary stuff :-)
> 
> Anyway, lots of thanks to Frank, Oleg, Ingo and others who commented on
> the last posting.
> 
> I guess most everybody is out having x-mas celebrations (and I will too not
> too long from now), so I expect replies to this won't happen until the new
> year, but who knows, maybe in between eating and drinking too much we all
> get an urge to stare at code.
> 
> Happy Holidays!

Also available from (once the mirror catches up):

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git

---
 arch/x86/include/asm/spinlock.h |   26 ++-
 arch/x86/kernel/smp.c           |    1 +
 include/linux/mutex.h           |    2 +-
 include/linux/sched.h           |   23 +-
 kernel/mutex-debug.c            |    2 +-
 kernel/mutex-debug.h            |    2 +-
 kernel/mutex.c                  |    2 +-
 kernel/mutex.h                  |    2 +-
 kernel/sched.c                  |  542 ++++++++++++++++++++++-----------------
 kernel/sched_debug.c            |    2 +-
 kernel/sched_fair.c             |    5 +-
 kernel/sched_features.h         |    2 +
 kernel/sched_idletask.c         |    2 +-
 kernel/sched_rt.c               |   20 +-
 kernel/sched_stoptask.c         |    5 +-
 15 files changed, 371 insertions(+), 267 deletions(-)

