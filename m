Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab0FIWEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:04:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab0FIWEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:04:47 -0400
Date: Thu, 10 Jun 2010 08:04:25 +1000
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100610080425.6f005dbb@notabene.brown>
In-Reply-To: <201006091140.28034.rjw@sisk.pl>
References: <20100603193045.GA7188@elte.hu>
	<alpine.LFD.2.00.1006082042020.4506@i5.linux-foundation.org>
	<AANLkTino9hnqao9402dR543MIlf66qYYjxrknHrxd39o@mail.gmail.com>
	<201006091140.28034.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010 11:40:27 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 09 June 2010, Felipe Contreras wrote:
> > On Wed, Jun 9, 2010 at 6:46 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > On Tue, 8 Jun 2010, david@lang.hm wrote:
> > >>
> > >> having suspend blockers inside the kernel adds significant complexity, it's
> > >> worth it only if the complexity buys you enough. In this case the question is
> > >> if the suspend blockers would extend the sleep time enough more to matter. As
> > >> per my other e-mail, this is an area with rapidly diminishing returns as the
> > >> sleep times get longer.
> > >
> > > Well, the counter-argument that nobody seems to have brought up is that
> > > suspend blockers exist, are real code, and end up being shipped in a lot
> > > of machines.
> > >
> > > That's a _big_ argument in favour of them. Certainly much bigger than
> > > arguing against them based on some complexity-arguments for an alternative
> > > that hasn't seen any testing at all.
> > >
> > > IOW, I would seriously hope that this discussion was more about real code
> > > that _exists_ and does what people need. It seems to have degenerated into
> > > something else.
> > >
> > > Because in the end, "code talks, bullshit walks". People can complain and
> > > suggest alternatives all they want, but you can't just argue. At some
> > > point you need to show the code that actually solves the problem.
> > 
> > That's assuming there is an actual problem, which according to all the
> > embedded people except android, there is not.
> 
> Yes, there is, but they've decided to ignore it.
> 
> > And if there is indeed such a problem (probably not big), it might be
> > solved properly by the time suspend blockers are merged, or few
> > releases after.
> 
> Not quite.  Have you followed all of the discussion, actually?
> 
> > Whatever the solution (or workaround) is, it would be nice if it could
> > be used by more than just android people, and it would also be nice to
> > do it without introducing user-space API that *nobody* likes and might
> > be quickly deprecated.
> 
> I agree with Linus and I don't have that much of a problem with the API that
> people seem to have.  In fact the much-hated user space API is just a char
> device driver with 3 ioctls (that can be extended in future if need be) and
> the kernel API is acceptable to me. 

I think there is a little bit more to it than that.  It seems there is a new
ioctl for input/event devices to say "Any events queued here should be
treated as wake-up events".  There may be similar additions to other devices,
but I know of no details.

I wonder if we can get a complete statement of changes to the user-space
API...

>                                       Yes, there is some overlap between it
> and PM QoS, but IMhO that overlap may be reduced over time (eg. by
> using PM QoS requirements to implement suspend blockers). 
> 
> To me, the question boils down to whether or not we're able to persuade the
> Android people to use any other approach (eg. by demonstrating that something
> else is actually better), because even if we invent a brilliant new approach,
> but Android ends up using its old one anyway, the net result will be as though
> we haven't done anything useful.

Yes.  There is no point unless we can meet somewhere in the middle.  I think
that would have to include a full suspend that freezes all processes.
Solutions which reject that - while quite clever - would require too much
change to Android user-space to be acceptable.

NeilBrown

> 
> Rafael

