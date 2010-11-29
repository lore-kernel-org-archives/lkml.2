Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0K2MbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:31:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50312 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0K2MbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:31:04 -0500
Date: Mon, 29 Nov 2010 13:30:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101129123042.GA26112@elte.hu>
References: <20101121133744.GA10765@elte.hu>
 <1290700829.4759.16.camel@maggy.simson.net>
 <1290954299.30515.15.camel@marge.simson.net>
 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
 <20101128201851.GA20555@elte.hu>
 <1291031593.32004.19.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291031593.32004.19.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sun, 2010-11-28 at 21:18 +0100, Ingo Molnar wrote:
> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > On Sun, Nov 28, 2010 at 6:24 AM, Mike Galbraith <efault@gmx.de> wrote:
> > > >
> > > > Something else is seriously wrong though.  36.1 with attached (plus
> > > > sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> > > > 37.git and tip with fixlet below both suck rocks.  With a make -j40
> > > > running, wakeup-latency is showing latencies of >100ms, amarok skips,
> > > > mouse lurches badly.. generally horrid.  Something went south.
> > > 
> > > Can you test -rc3? Is that still ok? And are you perhaps using
> > > Nouveau? There's a report of some graphics (?) regression since -rc3
> > > about bad desktop performance:
> > > 
> > >    https://bugzilla.kernel.org/show_bug.cgi?id=23912
> > > 
> > > but it doesn't have any more information yet (so if -rc3 _is_ good for
> > > you, and you can add anything to that report, it would be good. The
> > > original reporter is hopefully bisecting it now)
> > 
> > Mike, the last pure -rc3 -tip commit is 92c883adf03b - you could try to check that 
> > out too: it has most of the current sched/core commits, but has none of the post-rc3 
> > DRM changes.
> 

> Well we totally re-wrote the cgroup load-balancer in -tip. The thing currently in 
> -linus is a utter crap because its very strongly serialized across all cores (some 
> people spend like 25% of their time in there).

Yes, 92c883adf03b includes those changes:

 08f3c3065f4c: Merge branch 'sched/core'
 9437178f623a: sched: Update tg->shares after cpu.shares write
 d6b5591829bd: sched: Allow update_cfs_load() to update global load
 3b3d190ec368: sched: Implement demand based update_cfs_load()
 c66eaf619c0c: sched: Update shares on idle_balance
 a7a4f8a752ec: sched: Add sysctl_sched_shares_window
 67e86250f8ea: sched: Introduce hierarchal order on shares update list
 e33078baa4d3: sched: Fix update_cfs_load() synchronization
 f0d7442a5924: sched: Fix load corruption from update_cfs_shares()
 9e3081ca6114: sched: Make tg_shares_up() walk on-demand
 3d4b47b4b040: sched: Implement on-demand (active) cfs_rq list
 2069dd75c7d0: sched: Rewrite tg_shares_up)
 48c5ccae88dc: sched: Simplify cpu-hot-unplug task migration
 92fd4d4d67b9: Merge commit 'v2.6.37-rc2' into sched/core

I just wanted to give Mike a known-stable sha1 that has -rc3 but not the post-rc3 
DRM changes.

Thanks,

	Ingo
