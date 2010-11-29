Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0K2NpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:45:18 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39025 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753825Ab0K2NpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:45:16 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+orLwRHJSorIewldcPgBGXyU8E3doZHSzwftZnPh
	ABOkloOeMwQxtK
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
In-Reply-To: <20101129123042.GA26112@elte.hu>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <20101129123042.GA26112@elte.hu>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 14:45:10 +0100
Message-Id: <1291038310.17004.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 13:30 +0100, Ingo Molnar wrote: 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Sun, 2010-11-28 at 21:18 +0100, Ingo Molnar wrote:
> > > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > 
> > > > On Sun, Nov 28, 2010 at 6:24 AM, Mike Galbraith <efault@gmx.de> wrote:
> > > > >
> > > > > Something else is seriously wrong though.  36.1 with attached (plus
> > > > > sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> > > > > 37.git and tip with fixlet below both suck rocks.  With a make -j40
> > > > > running, wakeup-latency is showing latencies of >100ms, amarok skips,
> > > > > mouse lurches badly.. generally horrid.  Something went south.
> > > > 
> > > > Can you test -rc3? Is that still ok? And are you perhaps using
> > > > Nouveau? There's a report of some graphics (?) regression since -rc3
> > > > about bad desktop performance:
> > > > 
> > > >    https://bugzilla.kernel.org/show_bug.cgi?id=23912
> > > > 
> > > > but it doesn't have any more information yet (so if -rc3 _is_ good for
> > > > you, and you can add anything to that report, it would be good. The
> > > > original reporter is hopefully bisecting it now)
> > > 
> > > Mike, the last pure -rc3 -tip commit is 92c883adf03b - you could try to check that 
> > > out too: it has most of the current sched/core commits, but has none of the post-rc3 
> > > DRM changes.
> > 
> 
> > Well we totally re-wrote the cgroup load-balancer in -tip. The thing currently in 
> > -linus is a utter crap because its very strongly serialized across all cores (some 
> > people spend like 25% of their time in there).
> 
> Yes, 92c883adf03b includes those changes:
> 
>  08f3c3065f4c: Merge branch 'sched/core'
>  9437178f623a: sched: Update tg->shares after cpu.shares write
>  d6b5591829bd: sched: Allow update_cfs_load() to update global load
>  3b3d190ec368: sched: Implement demand based update_cfs_load()
>  c66eaf619c0c: sched: Update shares on idle_balance
>  a7a4f8a752ec: sched: Add sysctl_sched_shares_window
>  67e86250f8ea: sched: Introduce hierarchal order on shares update list
>  e33078baa4d3: sched: Fix update_cfs_load() synchronization
>  f0d7442a5924: sched: Fix load corruption from update_cfs_shares()
>  9e3081ca6114: sched: Make tg_shares_up() walk on-demand
>  3d4b47b4b040: sched: Implement on-demand (active) cfs_rq list
>  2069dd75c7d0: sched: Rewrite tg_shares_up)
>  48c5ccae88dc: sched: Simplify cpu-hot-unplug task migration
>  92fd4d4d67b9: Merge commit 'v2.6.37-rc2' into sched/core
> 
> I just wanted to give Mike a known-stable sha1 that has -rc3 but not the post-rc3 
> DRM changes.

The good news is that the 37.git kernel was mislabeled in grub, was also
booting the _tip_ kernel, and is actually just fine.  It's only tip, and
tip 92fd4d4d67b9 is still bad.  I'll try a quick bisect before getting
back to backlog.

	-Mike

