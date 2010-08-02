Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0HBM1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:27:32 -0400
Received: from thunk.org ([69.25.196.29]:57101 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab0HBM1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:27:31 -0400
Date: Mon, 2 Aug 2010 08:27:26 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: paulmck@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802122726.GA6247@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
	florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
	swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
	alan@lxorguk.ukuu.org.uk
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801204026.GH31324@thunk.org>
 <20100802030304.GU2470@linux.vnet.ibm.com>
 <20100801210548.23f77ff6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801210548.23f77ff6@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 09:05:48PM -0700, Arjan van de Ven wrote:
> I'm a little worried that this whole "I need to block suspend" is
> temporary. Yes today there is silicon from ARM and Intel where suspend
> is a heavy operation, yet at the same time it's not all THAT heavy
> anymore.... 

Part of the problem here may also be a naming problem.  There are
multiple reasons why you might want to block suspend, and it goes far
beyond what the CPU can do.

Let's give another example, from the laptop world.  If you close the
the MacBook, it "suspends".  That is, all processes stop, and the CPU
enters a sleep state.  Sounds just like Linux's suspend-to-ram, right?

Except for the fact that if you insert a USB cable connected to a
iPod/iPad/iPhone, the CPU wakes up, and iTunes will do a sync, and
then the machine goes back to sleep.  And if the Mail application is
in the middle of manipulating the IMAP mailbox, it will be allowed to
finish what it is doing, and then the system goes to sleep.

So in the case of both the MacBook, where the user has closed the
laptop, and in the case of Cell Phone, where the user has pushed the
button saying he/she's done working with the application, the _normal_
thing to do force all processes to go to sleep, and then let the CPU
go to sleep.

But, you may have applications that are specially privileged so they
can ignore the user command to suspend the machine.  Maybe it's an
iTunes-like situation, where in response to some hardware interrupt,
it's allowed to wake up, do its thing, and then go back to sleep,
allowing the hardware to go back to sleep.  Maybe it's a mail
application that wants to wakeup every 15 minutes, suck down any new
mail, and then go back to sleep.  The suspend blocker is a way to
achieve this --- and this has nothing to do with chip technology, but
with a specific use case.

						- Ted
