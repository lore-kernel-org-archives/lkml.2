Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab2DLXBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:01:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:39057 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab2DLXBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:01:51 -0400
Date: Fri, 13 Apr 2012 01:01:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sasikantha Babu <sasikanth.v19@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT pull] timer fixes for 3.4
In-Reply-To: <CA+55aFyLYxQgdevFwjwzVrU_B87n5a6P_=9pcWzjKZ0C6RtU5g@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204130058370.2542@ionos>
References: <alpine.LFD.2.02.1204130004080.2542@ionos> <CA+55aFxg0rzpL-xCqdScxPKPMupbvteoXD1cPT-fWYpyMXoSGg@mail.gmail.com> <alpine.LFD.2.02.1204130022520.2542@ionos> <CA+55aFzP-DmGUqGcnxj2mq-mvmOXA7k-zgOrdDRY3WA9N5dmBg@mail.gmail.com>
 <alpine.LFD.2.02.1204130037060.2542@ionos> <CA+55aFyLYxQgdevFwjwzVrU_B87n5a6P_=9pcWzjKZ0C6RtU5g@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012, Linus Torvalds wrote:

> On Thu, Apr 12, 2012 at 3:39 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> That said, would people actually *report* those messages?
> >>
> >> In general, for things like this, it's probably better to just make
> >> the change (especially if you have several distros you can test), and
> >> then add a printk_once() for the case that changed. Then, if people
> >
> > I changed it to a printk_once() already.
> 
> No, I meant that the whole message should probably have been added
> when actually changing the semantics.
> 
> If you have good reason to believe that some ABI change (a) does not
> actually have any reason to break anything and (b) worth doing, then I
> think it should just have been done (but during the merge window only,
> of course).
> 
> And if (a) or (b) aren't true, then we're not going to change the ABI
> at all, so the whole point is moot.
> 
> The printk_once (or, for that case WARN_ON_ONCE() may even be
> worthwhile) would then just be a "oops, we were wrong" kind of
> message, and would just mean that the commit would be reverted.
> 
> I think the whole "let's deprecate this six months into the future" is
> unnecessary. Yes, it may well be worth doing for something with bigger
> consequences, but I think that for something like this, it's just
> overthinking the issue.
> 
> If it really is something we want to fix, I think it's much better to
> just say "let's fix it, and if somebody notices, we'll have to go
> back". The printk_once or WARN_ON is then just a polite way to avoid
> having people have to bisect to it etc if it's subtle (and then we
> would plan to remove *that* later).

Fair enough.

Though last time I tried to do that (IIRC, it was a sanity check on a
timespec) I was forced to go the deprecation way ....

Times are changing :)

      tglx
