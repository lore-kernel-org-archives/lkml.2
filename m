Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab0FEWUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:20:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:42337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab0FEWUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:20:51 -0400
Date: Sat, 5 Jun 2010 15:23:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
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
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100605152326.7ccd5160@infradead.org>
In-Reply-To: <AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	<20100604071354.GA14451@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 14:26:14 -0700
Arve Hjønnevåg <arve@android.com> wrote:

> On Sat, Jun 5, 2010 at 9:28 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Sat, 05 Jun 2010 11:54:13 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> >
> >> On Fri, 2010-06-04 at 17:10 -0700, Arve Hjønnevåg wrote:
> >> > > Trusted processes are assumed to be sane and idle when there is
> >> > > nothing for them to do, allowing the machine to go into deep
> >> > > idle states.
> >> > >
> >> >
> >> > Neither the kernel nor our trusted user-space code currently
> >> > meets this criteria.
> >>
> >> Then both need fixing. Really, that's the only sane approach.
> >
> > fwiw... in MeeGo we're seeing quite good idle times (> 1 seconds)
> > without really bad hacks.
> >
> 
> We clearly have different standards for what we consider good. We
> measure time suspended in minutes or hours, not seconds, and waking up
> every second or two causes a noticeable decrease in battery life on
> the hardware we have today.

I guess I'm spoiled working with (unreleased) hardware that knows how
to power gate ;-)


> 
> > the kernel has a set of infrastructure already to help here (range
> > timers, with which you can wakeup-limit untrusted userspace crap),
> > timer slack for legacy background timers, etc etc.
> 
> Range timers allows the kernel to align different timers so they don't
> each bring the cpu out of idle individually. They do not eliminate
> timers or make individual timers fire less often.

you're incorrect.
With range timers you can control the rate at which timers fire just
fine. 

For example if the Adobe Flash player puts a timer every 10
milliseconds (yes it does that), and you give it a 3.99 seconds range,
it will fire its timers every 4 seconds.... unless other activity
happens independently, at which point it'll align with that instead.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
