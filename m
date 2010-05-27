Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab0E0Prw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:47:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59882 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932304Ab0E0Pru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:47:50 -0400
Date: Thu, 27 May 2010 11:47:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       <Paul@smtp1.linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <1274974479.27810.5247.camel@twins>
Message-ID: <Pine.LNX.4.44L0.1005271141410.3239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Peter Zijlstra wrote:

> On Thu, 2010-05-27 at 16:33 +0100, Alan Cox wrote:
> > On Thu, 27 May 2010 17:09:16 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, 2010-05-27 at 11:06 -0400, Alan Stern wrote:
> > > > 
> > > >         Opportunistic suspends are okay.
> > > > 
> > > >         The proposed userspace API is too Android-specific.
> > > 
> > > I would argue opportunistic suspends are not ok, and therefore the
> > > proposed API is utterly irrelevant.
> > 
> > Assuming you are happy that opportunistically entering C6 and the like is
> > ok via ACPI can you explain why you have a problem with opportunistic
> > suspend and why it is different to a very deep sleep CPU state such as we
> > have now (and which on many embedded platforms we deal with *is* sleeping
> > external devices too)
> 
> Agreed, but I understood the opportunistic suspend line from Alan Stern
> to mean the echo opportunistic > /sys/power/foo thing.

Yes, that's what I meant.  Why do you think it is any worse than "echo 
mem >/sys/power/state"?  The only difference is that it will block 
until all in-kernel suspend blockers are disabled.

Or do you also think that "echo mem >/sys/power/state" is evil and 
should be removed from the kernel as soon as possible?

And to answer Thomas's question: The whole reason for having in-kernel 
suspend blockers is so that userspace can tell the system to suspend 
without losing wakeup events.

Suppose a key is pressed just as a user program writes "mem" to
/sys/power/state.  The keyboard driver handles the keystroke and queues
an input event.  Then the system suspends and doesn't wake up until
some other event occurs -- even though the keypress was an important
one and it should have prevented the system from suspending.

With in-kernel suspend blockers and opportunistic suspend, this 
scenario is prevented.  That is their raison-d'etre.

Alan Stern

