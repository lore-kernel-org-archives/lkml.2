Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab1FEH5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:57:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42808 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754696Ab1FEH5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:57:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Dcip0oZ7DUk7CindL1sD3GpMmBNp9ZwfFXI332N
	LGDhfZSWFndIzG
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
From: Mike Galbraith <efault@gmx.de>
To: Arne Jansen <lists@die-jansens.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        linux-tip-commits@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4DEB1BD6.6070405@die-jansens.de>
References: <20110405152729.232781355@chello.nl>
	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
	 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
	 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
	 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
	 <1307092535.2353.2973.camel@twins> <4DE8B13D.9020302@die-jansens.de>
	 <BANLkTimhWnpgtcxjVA5Yj8_Dy5PA34EFJQ@mail.gmail.com>
	 <4DE8DC28.30709@die-jansens.de>
	 <BANLkTikXU5FFgY4=8MEdRjvt4gbpxm7J5g@mail.gmail.com>
	 <1307225323.2497.730.camel@laptop>  <4DEB1BD6.6070405@die-jansens.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 05 Jun 2011 09:57:40 +0200
Message-ID: <1307260660.9019.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 08:01 +0200, Arne Jansen wrote:
> On 05.06.2011 00:08, Peter Zijlstra wrote:
> > On Sun, 2011-06-05 at 06:29 +0900, Linus Torvalds wrote:
> >> On Fri, Jun 3, 2011 at 10:05 PM, Arne Jansen<lists@die-jansens.de>  wrote:
> >>>
> >>> No change. Also git bisect quite clearly points to
> >>> 0122ec5b02f766c and ab2515c4b98f7bc4, both are older than
> >>> b1c43f82c5aa2654 mentioned in the other thread.
> >>
> >> Ok, I haven't heard anything further on this. Ingo? Peter?
> >
> > I'm a bit stumped, and not being able to reproduce at all :/
> 
> I'm willing to take any number of round trips to get to the true
> nature of the bug. From the description I have a feeling that the
> offending patch might just shift the timing slightly, so even if
> the problem is gone for me, it might just be buried deeper.
> I can also try to reproduce it on a second machine and give you
> access to it, though this might take a few days.

My x3550 M3 with your config plus a couple drivers I need is exhibiting
hard lockups with no watchdog triggered.  If I use both serial and tty
consoles, I get all kinds of gripes from soft lockup and rcu when
loading Peter's test module, but that's the tty problem.

With serial console and earlyprintk=serial alone, box may or may not
boot all the way without hard locking silently.  Ditto on restart after
loading/unloading Peter's test module.  I always see all 10k messages
though, IFF I have no tty console active.

	-Mike

