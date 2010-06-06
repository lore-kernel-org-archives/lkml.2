Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0FFPq7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:46:59 -0400
Received: from www.tglx.de ([62.245.132.106]:51093 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab0FFPq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:46:57 -0400
Date: Sun, 6 Jun 2010 17:46:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@suse.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <1275834706.7227.545.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
References: <1275834706.7227.545.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010, James Bottomley wrote:
>
>      3. We've lost sight of one of the original goals, which was to
>         bring the android tree close enough to the kernel so that the
>         android downstream driver and board producers don't have to
>         choose between the android kernel and vanilla kernel.

There are two ways to do that w/o creating a dependcy on anything.

1) merge the drivers w/o the suspend_blockers. It's not rocket science
   to have a patch which brings them back for android.

2) merge the drivers with empty stub implementations for annotation.
   android just has to patch in the real one.

While I'd prefer #1, I' not in the way of #2.

Both ways can get the drivers into the kernel and it could/should have
been done right from the beginning, but now we face a situation where
drivers are held hostage.

Then we can sit down more relaxed and fix the stuff in a way which
makes both sides happy. If we manage to replace them, we can deprecate
the stub implementation and remove it after a grace period. If we
rename them it's not an issue either. We can rename them right away to
a qos interface, but that does not really make a difference.

What we really want to avoid is implementing an user space contract in
a frenzy which binds us forever.

It's not the suspend_blockers which are the causing the nightmare,
it's solely the drivers itself especially when there are different
implementations in both trees. And frankly, the drivers in android are
not in a shape which makes them flood in within 2 weeks. That's
serious work to get them brushed up and polished. So that gives us
quite a period of time to solve the suspend problem.

Thanks,

	tglx
