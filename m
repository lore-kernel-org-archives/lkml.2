Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0FFRIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 13:08:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0FFRIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 13:08:44 -0400
Subject: Re: [linux-pm] suspend blockers & Android integration
From: James Bottomley <James.Bottomley@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
In-Reply-To: <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
References: <1275834706.7227.545.camel@mulgrave.site>
	 <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 12:08:34 -0500
Message-ID: <1275844114.7227.552.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-06-06 at 17:46 +0200, Thomas Gleixner wrote:
> On Sun, 6 Jun 2010, James Bottomley wrote:
> >
> >      3. We've lost sight of one of the original goals, which was to
> >         bring the android tree close enough to the kernel so that the
> >         android downstream driver and board producers don't have to
> >         choose between the android kernel and vanilla kernel.
> 
> There are two ways to do that w/o creating a dependcy on anything.
> 
> 1) merge the drivers w/o the suspend_blockers. It's not rocket science
>    to have a patch which brings them back for android.

Well, we sort of tried this when Greg pulled some of them into the
staging tree.  The problem is that without the annotations, the drivers
are still different, and patches won't apply, so, unsurprisingly, they
didn't get improved or even maintained.

> 2) merge the drivers with empty stub implementations for annotation.
>    android just has to patch in the real one.

That's also possible.  This time, we would have a cosmetically closer
tree ... however, what's in the kernel wouldn't be compilable for
android ... which is where all the downstream wants to test, so they'd
still be building for the android tree ... we just might have an easier
time of it picking up their fixes.

> While I'd prefer #1, I' not in the way of #2.

I think 1 is unviable ... I'm not opposed to 2 but I'd like to try to
get the kernel really closer to android before we go for the cosmetic
only option.

> Both ways can get the drivers into the kernel and it could/should have
> been done right from the beginning, but now we face a situation where
> drivers are held hostage.
> 
> Then we can sit down more relaxed and fix the stuff in a way which
> makes both sides happy. If we manage to replace them, we can deprecate
> the stub implementation and remove it after a grace period. If we
> rename them it's not an issue either. We can rename them right away to
> a qos interface, but that does not really make a difference.
> 
> What we really want to avoid is implementing an user space contract in
> a frenzy which binds us forever.

Well, that's why the QoS proposal ... it already has a userspace API ...
we'd just be extending it for statistics, which looks like a wothwhile
goal independent of android anyway.

> It's not the suspend_blockers which are the causing the nightmare,
> it's solely the drivers itself especially when there are different
> implementations in both trees. And frankly, the drivers in android are
> not in a shape which makes them flood in within 2 weeks. That's
> serious work to get them brushed up and polished. So that gives us
> quite a period of time to solve the suspend problem.

Right, so the sooner we make it easier for the drivers to use the kernel
as their main repository, the better.

James


