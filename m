Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1JYPOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:14:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51426 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752672Ab1JYPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:14:54 -0400
Date: Tue, 25 Oct 2011 11:14:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: mark gross <markgross@thegnar.org>
cc: NeilBrown <neilb@suse.de>, <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <arve@android.com>,
        <amit.kucheria@linaro.org>, <farrowg@sg.ibm.com>,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        <linux-pm@lists.linux-foundation.org>, <khilman@ti.com>,
        Magnus Damm <damm@opensource.se>, <mjg@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
In-Reply-To: <20111025045046.GA8383@mgross-G62>
Message-ID: <Pine.LNX.4.44L0.1110251105221.3089-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011, mark gross wrote:

> > > Timeout?  why can't we define a proper notification handshake for such
> > > things?  Timeouts are never right IMO.
> > > 
> > 
> > I thought that before, but I have come around to the opposite way of thinking
> > thanks to some instructive examples from Alan and Rafael.
> > 
> > Some things are simply not visible to the OS.  We can expect them to be
> > happening but we cannot be sure and there is no clear signal that they aren't
> > actually happening.  So we need a timeout.
> 
> um

> > - USB cannot (I think) know which USB device triggered a wake-from-suspend,
> >   and in any case cannot directly ask the device why it woke from suspend.
> >   It has to wait for the device to tell it (in response to a regular
> >   'interrupt' poll I assume - but it isn't guaranteed to be reported on the
> >   first poll) - or timeout and give up waiting.
> maybe if you are unwilling to change the user mode stack that is reading
> these events.  But if you where they you shouldn't need time outs.

Remember, here we are talking about timeouts in the kernel stack, not
in the user-mode stack.

So consider this theoretical situation (which is not very different
from reality): The system gets a wakeup signal.  Sometime in the next
30 ms or less, there may or may not be an input event -- the kernel has
no way to tell other than wait and see.

The kernel could simply go right back to sleep without waiting, but if
it does and there is a pending input event, then very quickly it will
get another wakeup signal, and it'll be right back where it started -- 
trying to decide whether to stay awake for the next 30 ms.

Can you suggest a way to handle this other than using a timeout?

Alan Stern

