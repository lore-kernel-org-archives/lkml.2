Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab1FASlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:41:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35236 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1FASlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:41:03 -0400
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Arne Jansen <lists@die-jansens.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1306951751.2497.626.camel@laptop>
References: <20110405152729.232781355@chello.nl>
	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
	 <4DE674EB.1000200@die-jansens.de>  <1306951751.2497.626.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 20:44:30 +0200
Message-ID: <1306953870.2497.627.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 20:09 +0200, Peter Zijlstra wrote:
> On Wed, 2011-06-01 at 19:20 +0200, Arne Jansen wrote:
> > On 01.06.2011 18:35, Peter Zijlstra wrote:
> > > On Wed, 2011-06-01 at 15:58 +0200, Arne Jansen wrote:
> > >> git bisect blames this commit for a problem I have with v3.0-rc1:
> > >> If I printk large amounts of data, the machine locks up.
> > >> As the commit does not revert cleanly on top of 3.0, I haven't been
> > >> able to double check.
> > >> The test I use is simple, just add something like
> > >>
> > >> for (i=0; i<  10000; ++i) printk("test %d\n", i);
> > >>
> > >> and trigger it, in most cases I can see the first 10 printks before
> > >> I have to power cycle the machine (sysrq-b does not work anymore).
> > >> Attached my .config.
> > >
> > > I've made me a module that does the above, I've also changed my .config
> > > to match yours (smp=y, sched-cgroup=y, autogroup=n, preempt=n, no_hz=y),
> > > but sadly I cannot reproduce, I get all 10k prints on my serial line.
> > >
> > > Even without serial line it works (somehow booting without visible
> > > console is scary as hell :)
> > >
> > > Which makes me ask, how are you observing your console?
> > >
> > 
> > They don't go out to the serial line, I only observe them with a
> > tail -f on messages. Default log level doesn't go the console here.
> 
> Right ok, so I used your exact .config, added a few drivers needed for
> my hardware and indeed, it doesn't even finish booting and gets stuck
> someplace.
> 
> Sadly it looks like even the NMI watchdog is dead,.. /me goes try and
> make sense of this.

Sadly both 0122ec5b02f766c355b3168df53a6c038a24fa0d^1 and
0122ec5b02f766c355b3168df53a6c038a24fa0d itself boot just fine and run
the test module without problems.

I will have to re-bisect this.

