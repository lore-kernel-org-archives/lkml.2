Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab0FEWvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:51:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab0FEWvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:51:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Brian Swetland <swetland@google.com>
Subject: Re: suspend blockers & Android integration
Date: Sun, 6 Jun 2010 00:52:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>,
       Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Neil Brown <neilb@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <20100605152326.7ccd5160@infradead.org> <AANLkTinRH52dSTPCAO9k1yEFup1LLYizeinunxeTBzbQ@mail.gmail.com>
In-Reply-To: <AANLkTinRH52dSTPCAO9k1yEFup1LLYizeinunxeTBzbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006060052.21501.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 June 2010, Brian Swetland wrote:
> On Sat, Jun 5, 2010 at 3:23 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> >>
> >> We clearly have different standards for what we consider good. We
> >> measure time suspended in minutes or hours, not seconds, and waking up
> >> every second or two causes a noticeable decrease in battery life on
> >> the hardware we have today.
> >
> > I guess I'm spoiled working with (unreleased) hardware that knows how
> > to power gate ;-)
> 
> I'm continually surprised by answers like this.  We run on hardware
> that power gates very aggressively and draws in the neighborhood of
> 1-2mA at the battery when in the lowest state (3-5mA while the radio
> is connected to the network and paging).  Waking up out of that lowest
> state and executing code every few seconds or (worse) several times a
> second) will raise your average power consumption.  Being able to stay
> parked at the very bottom for minutes or hours at a time when nothing
> "interesting" is happening is very useful and can have a significant
> impact on overall battery life.

Yes, and if you look at the approach I proposed in this very thread
(http://lkml.org/lkml/2010/6/4/368), it goes exactly in this direction.

And I think it is superior to the opportunistic suspend framework you have
right now, because, for example, it doesn't require you to carry out full
system resume and full system suspend every once a while to check battery
status.

And guess what, suspending and resuming the whole system actually uses energy.

Rafael
