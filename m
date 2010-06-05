Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849Ab0FEXqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:46:34 -0400
Received: from www.tglx.de ([62.245.132.106]:36872 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933775Ab0FEXqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:46:32 -0400
Date: Sun, 6 Jun 2010 01:45:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Brian Swetland <swetland@google.com>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Neil Brown <neilb@suse.de>,
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
In-Reply-To: <20100605154833.7d05e404@infradead.org>
Message-ID: <alpine.LFD.2.00.1006060134160.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu> <20100603231153.GA11302@elte.hu> <20100603232302.GA16184@elte.hu> <AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com> <20100604071354.GA14451@elte.hu> <AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
 <20100604083423.GD15181@elte.hu> <AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com> <1275653210.27810.39762.camel@twins> <AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com> <1275731653.27810.41078.camel@twins> <20100605092851.6ee15f13@infradead.org>
 <AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com> <20100605152326.7ccd5160@infradead.org> <AANLkTinRH52dSTPCAO9k1yEFup1LLYizeinunxeTBzbQ@mail.gmail.com> <20100605154833.7d05e404@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010, Arjan van de Ven wrote:

> On Sat, 5 Jun 2010 15:26:36 -0700
> Brian Swetland <swetland@google.com> wrote:
> 
> > 
> > I'm continually surprised by answers like this.  We run on hardware
> > that power gates very aggressively and draws in the neighborhood of
> > 1-2mA at the battery when in the lowest state (3-5mA while the radio
> > is connected to the network and paging).  Waking up out of that lowest
> > state and executing code every few seconds or (worse) several times a
> > second) will raise your average power consumption.  Being able to stay
> > parked at the very bottom for minutes or hours at a time when nothing
> > "interesting" is happening is very useful and can have a significant
> > impact on overall battery life.
> 
> It's relatively simple math.
> 
> If you wake up for a burst of work, you burn power at the higher level
> P1 (versus the lower power level P2), for, lets say an average time T,
> with a relatively small T (few milliseconds at most).
> 
> If you wake up X times per second (with X being a fractional number, so
> can be smaller than 1) the extra power consumption factor is
> 
>           X * T * P1
> -------------------------------
> X * T * P1 + (1.0 - X * T) * P2
> 
> if you draw a graph of this, for real values of P and T, there's a real
> point where you hit diminishing returns.
> 
> if say T is 5 milliseconds (that's a high amount), and X is 1
> wakeup/second, then there's already a 200:1 ratio in time an power.
> 
> If X goes to once every 10 seconds (not unreasonable, especially since
> any real device will pull email and stuff in the backgroudn), you have
> 2000:1 time and power ratios...
> 
> Unless your "on" power is insane high (and hopefully it's not, since
> you're not turning on the whole device obviously, you do selective
> power and clock gating)... that "divide by 200 or 2000" makes the whole
> problem go away.. in the "seconds" range for really low power devices.
> Not in "hours" range. 

That's the whole problem. Suspend blockers are a binary all on/off
approach so you waste power just to get the thing back to
"suspend". They unleash the world and some more just to put it back
into oblivion with brute force.

Thanks,

	tglx
