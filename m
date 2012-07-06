Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab2GFQxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:53:23 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37343 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab2GFQxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:53:22 -0400
Date: Fri, 6 Jul 2012 12:52:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org
Subject: Re: [PATCH 01/10] random: make 'add_interrupt_randomness()' do
 something sane
Message-ID: <20120706165257.GD10798@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	w@1wt.eu, ewust@umich.edu, zakir@umich.edu, greg@kroah.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net, stable@kernel.org
References: <CA+55aFyMYVLCW0OYTVttkjjOwyu9VgDM9haNC=BeoRCEiWWNPQ@mail.gmail.com>
 <1341524367.4020.1324.camel@calx>
 <CA+55aFxAe1pRN+jvdLveHQ+nNRNC6HDZ+S4Y9P202rxgNLN8pg@mail.gmail.com>
 <20120705220040.GA15685@thunk.org>
 <CA+55aFzFMZpiDMJO9UxoXSjOCzvxn7tgvmAHLM36OmaiMasQhw@mail.gmail.com>
 <1341527482.4020.1355.camel@calx>
 <20120705232136.GD15685@thunk.org>
 <CA+55aFxhobNMY5RLmH+tKox8voqfH-bVqKVF03JeeVrHkhLcaQ@mail.gmail.com>
 <20120706130127.GB10798@thunk.org>
 <CA+55aFw90o8btDJhztkS=2NXiZvXNAkCsZkx-p9+RRx-cMQc6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw90o8btDJhztkS=2NXiZvXNAkCsZkx-p9+RRx-cMQc6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 09:24:00AM -0700, Linus Torvalds wrote:
> On Fri, Jul 6, 2012 at 6:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > What in the world is "fast count"?  I've grepped for it,
> > and I can't find it.
> 
> It's your own fast-pool counter that Matt was talking about.

When he said "check it against HZ", it confused me, since there's no
way to compare it against HZ.  But yes, I can certainly not give any
credit for entropy if __IRQF_TIMER is set, or keep track of whether
the previous interrupt had __IRQF_TIMER set in its descriptor.  That's
simple enough.

I thought he was saying there was some way to distinguish between
interrupts triggered by the clock interrupt versus other devices on
the same irq channel --- and I couldn't figure out any to do that in
an architecture independent way.

					- Ted

