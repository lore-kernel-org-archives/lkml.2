Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab0FJJBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:01:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47245 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab0FJJBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:01:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Organization: SiSK
To: Neil Brown <neilb@suse.de>
Subject: Re: [linux-pm] suspend blockers & Android integration
Date: Thu, 10 Jun 2010 10:59:43 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Alan Stern <stern@rowland.harvard.edu>
References: <20100603193045.GA7188@elte.hu> <201006091140.28034.rjw@sisk.pl> <20100610080425.6f005dbb@notabene.brown>
In-Reply-To: <20100610080425.6f005dbb@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006101059.44411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 10, 2010, Neil Brown wrote:
> On Wed, 9 Jun 2010 11:40:27 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday 09 June 2010, Felipe Contreras wrote:
> > > On Wed, Jun 9, 2010 at 6:46 AM, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > > On Tue, 8 Jun 2010, david@lang.hm wrote:
> > > >>
> > > >> having suspend blockers inside the kernel adds significant complexity, it's
> > > >> worth it only if the complexity buys you enough. In this case the question is
> > > >> if the suspend blockers would extend the sleep time enough more to matter. As
> > > >> per my other e-mail, this is an area with rapidly diminishing returns as the
> > > >> sleep times get longer.
> > > >
> > > > Well, the counter-argument that nobody seems to have brought up is that
> > > > suspend blockers exist, are real code, and end up being shipped in a lot
> > > > of machines.
> > > >
> > > > That's a _big_ argument in favour of them. Certainly much bigger than
> > > > arguing against them based on some complexity-arguments for an alternative
> > > > that hasn't seen any testing at all.
> > > >
> > > > IOW, I would seriously hope that this discussion was more about real code
> > > > that _exists_ and does what people need. It seems to have degenerated into
> > > > something else.
> > > >
> > > > Because in the end, "code talks, bullshit walks". People can complain and
> > > > suggest alternatives all they want, but you can't just argue. At some
> > > > point you need to show the code that actually solves the problem.
> > > 
> > > That's assuming there is an actual problem, which according to all the
> > > embedded people except android, there is not.
> > 
> > Yes, there is, but they've decided to ignore it.
> > 
> > > And if there is indeed such a problem (probably not big), it might be
> > > solved properly by the time suspend blockers are merged, or few
> > > releases after.
> > 
> > Not quite.  Have you followed all of the discussion, actually?
> > 
> > > Whatever the solution (or workaround) is, it would be nice if it could
> > > be used by more than just android people, and it would also be nice to
> > > do it without introducing user-space API that *nobody* likes and might
> > > be quickly deprecated.
> > 
> > I agree with Linus and I don't have that much of a problem with the API that
> > people seem to have.  In fact the much-hated user space API is just a char
> > device driver with 3 ioctls (that can be extended in future if need be) and
> > the kernel API is acceptable to me. 
> 
> I think there is a little bit more to it than that.  It seems there is a new
> ioctl for input/event devices to say "Any events queued here should be
> treated as wake-up events".  There may be similar additions to other devices,
> but I know of no details.

That's not in the patchset as in my pull request.

It is used on Android, though, and it would have been submitted separately, had
the first patchset been merged.

> I wonder if we can get a complete statement of changes to the user-space
> API...
> 
> >                                       Yes, there is some overlap between it
> > and PM QoS, but IMhO that overlap may be reduced over time (eg. by
> > using PM QoS requirements to implement suspend blockers). 
> > 
> > To me, the question boils down to whether or not we're able to persuade the
> > Android people to use any other approach (eg. by demonstrating that something
> > else is actually better), because even if we invent a brilliant new approach,
> > but Android ends up using its old one anyway, the net result will be as though
> > we haven't done anything useful.
> 
> Yes.  There is no point unless we can meet somewhere in the middle.  I think
> that would have to include a full suspend that freezes all processes.
> Solutions which reject that - while quite clever - would require too much
> change to Android user-space to be acceptable.

Moreover, having thought a bit more about the "power manager in user space"
concept I'm not sure if it really is that better than the original wakelocks
idea.  Namely, it only repaces a kernel-based mechanism with a user space
task doing basically the same thing, but the communication between that task
and the other cooperating user space tasks is arguably more complicated (it
also uses the kernel resources, although indirectly).

So, for a phone-like system, where you'd generally want to simplify user space,
having a "power manager" in the kernel seems to make sense to me.

Rafael
