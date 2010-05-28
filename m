Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab0E1OOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:14:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45184 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755739Ab0E1OOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:14:02 -0400
Date: Fri, 28 May 2010 15:20:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: Igor Stoppa <igor.stoppa@nokia.com>,
       ext Matthew Garrett <mjg59@srcf.ucam.org>,
       "tytso@mit.edu" <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100528152037.2568f2fb@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
	<4BFFC5DF.5030504@nokia.com>
	<AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That's very good. But if it is done in a conceptually flawed way, some
> > better solution should be considered for upstream merge.
> 
> How is it flawed?  Serious question.

- It means changing drivers and quite a few apps
- It doesn't solve the problem of rogue apps if they end up owning locks
- It puts the deep knowledge of the platform in the applications
- It gives the apps control of the action taken not policy indication
- It doesn't resolve the problem of synchronization of take/releases
  stopping any suspend
- The kernel parts are not generically useful, merely effective for
  solving a specific problem right now - even things like VM migration
  to/from phones seems to break it
- It inverts the whole logic the kernel is following and trend it is
  following that suspend is simply a very deep idle (with implementations
  merged)

If it was a localised turd I wouldn't worry. There are plenty df deep
unmentionables hidden away enirely in platform specific code that deal
with everything from stoned hardware engineers to crazed software stack
implementations.

Here is a question back the other way perhaps

- If the existing kerne was almostl entirely read only, or you had to pay
  a large fee per line of code changed outside your own driver how would
  you implement the wakelock/suspend blocker API ?

Because if you take the path that 'we want wakelockers' that is
essentially the question you have to answer. How do you merge it so that
nobody outside of your driver and maybe a spot of arch code knows about
it. You are permitted a couple of sneaky substitions of core function
bits in headers.

Right now bits are going to leak out over the kernel which is the cause of
friction. At the point it's invisible to everyone else they cease to be
stakeholders so you don't have keep them happy. You've only got a couple
in your patches but its painfully obvious from Matthew and your comments
you'll end up needing a ton more and these will get everywhere as Android
grows hardware platforms and CPU support as phones become more featureful
and PC like. The moment a phone grows a USB base station with hub for
example the entire USB stack becomes burdened with them. Matthew has
already indicated networking needs them. Good luck with Dave Miller on
that.

I'm asking questions to look for generalised approaches, or even better
doing it without new kernel stuff in the first place, but it's not the
only way.

Alan
