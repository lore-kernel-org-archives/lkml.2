Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0K2LxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 06:53:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:35879 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab0K2LxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 06:53:03 -0500
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
In-Reply-To: <20101128201851.GA20555@elte.hu>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 12:53:13 +0100
Message-ID: <1291031593.32004.19.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 21:18 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sun, Nov 28, 2010 at 6:24 AM, Mike Galbraith <efault@gmx.de> wrote:
> > >
> > > Something else is seriously wrong though.  36.1 with attached (plus
> > > sched, cgroup: Fixup broken cgroup movement) works a treat, whereas
> > > 37.git and tip with fixlet below both suck rocks.  With a make -j40
> > > running, wakeup-latency is showing latencies of >100ms, amarok skips,
> > > mouse lurches badly.. generally horrid.  Something went south.
> > 
> > Can you test -rc3? Is that still ok? And are you perhaps using
> > Nouveau? There's a report of some graphics (?) regression since -rc3
> > about bad desktop performance:
> > 
> >    https://bugzilla.kernel.org/show_bug.cgi?id=23912
> > 
> > but it doesn't have any more information yet (so if -rc3 _is_ good for
> > you, and you can add anything to that report, it would be good. The
> > original reporter is hopefully bisecting it now)
> 
> Mike, the last pure -rc3 -tip commit is 92c883adf03b - you could try to check that 
> out too: it has most of the current sched/core commits, but has none of the post-rc3 
> DRM changes.

Well we totally re-wrote the cgroup load-balancer in -tip. The thing
currently in -linus is a utter crap because its very strongly serialized
across all cores (some people spend like 25% of their time in there).
