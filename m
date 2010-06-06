Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0FFW1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 18:27:43 -0400
Received: from www.tglx.de ([62.245.132.106]:42156 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0FFW1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 18:27:41 -0400
Date: Mon, 7 Jun 2010 00:26:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Swetland <swetland@google.com>
cc: Christoph Hellwig <hch@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>, Arve Hj?nnev?g <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006070014380.2933@localhost.localdomain>
References: <1275834706.7227.545.camel@mulgrave.site> <alpine.LFD.2.00.1006061725000.2933@localhost.localdomain> <1275844114.7227.552.camel@mulgrave.site> <20100606190525.GA20517@infradead.org> <AANLkTikKx-gXCGtNo3woHLCpBoEQ7hG9Jbiq3hwUTW_w@mail.gmail.com>
 <20100606192405.GA7559@infradead.org> <AANLkTikA0ihlbehyyN-zQ3mN4WmlZJYBSRTYV8SbDhSr@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-705175777-1275863218=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-705175777-1275863218=:2933
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Brian,

On Sun, 6 Jun 2010, Brian Swetland wrote:

> On Sun, Jun 6, 2010 at 12:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> >
> > Yes.  That's what makes me wonder about some parts of the discussion
> > here.  Getting the drivers for one or more of the android plattforms
> > in is not a problem.  I'd say it could have easily been done with the
> > manweeks spent arguing in this and related threads.
> >
> > The much bigger issues is to get android userspace running on a more
> > or less vanilla kernel, that is withoutthe  binder, without the rather
> > interesting group ID based security hack^H^H^H^Hmodel, without the
> > suspend blocker userspace API and so on, and so on.
> 
> Somebody will have to broker a deal with the frameworks/apps folks to
> get rid of the binder.  They like it a lot.  Of course if somebody
> built a drop-in replacement for the userspace side that didn't require
> a kernel driver, had the same performance characteristics, solved the
> same problems, etc, they could probably make an argument for it (or
> just provide it as a drop-in replacement for people who want a more
> "pure" linux underneath Android, even if we didn't pick it up).
> 
> The group ID stuff works incredibly well for gating device access --
> we ensure that devices that need access from various processes end up
> with perms like 0660 root audio (say for a raw audio interface), and
> then we assure that processes which have the "may use audio hardware"
> permission are executed with audio as an additional group.  We ended
> up using the same model to control socket, raw socket, and bt socket
> access because at the time we could not find a reasonable way to grant
> or exclude such permissions on a process by process basis.
> Maintaining about 20-30 lines of diffs to make that work was not a bad
> tradeoff (and we don't expect those patches to go upstream).  If
> there's a way to accomplish this without patching the kernel, we're
> all ears.
> 
> While we do maintain some assorted patches to core code (like the
> permissions thing), we strongly prefer to keep our work localized to
> drivers (generic to android or specific to hardware), and try to
> migrate to common kernel features when possible, submit patches (like
> work Mike Chan is doing around cpufreq and power measurement), etc.
> Patches to core code cause more headaches when we rebase up to new
> kernel versions, after all.

thanks for the honest answer and thanks to Christoph for the
reminder! 

That takes a lot of the bullshit arguments about downstream users
being hurt out of the discussion. The above problems are way more
complex to resolve than the suspend blocker details.

That's another prove why we can let the drivers flow in (in the worst
case w/o the suspend blocker stubs) and have no pressure to resolve
the suspend blocker problem yesterday.

That said, after thinking more about it, I'm advocating the stubs
solution with a clear removal / decision date constraint
(e.g. 2.6.37), as it forces all involved parties to stay tuned and not
to forget about it. I'm curious about the outcome :)

Thanks,

	tglx
--8323328-705175777-1275863218=:2933--
