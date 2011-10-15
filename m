Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1JOSpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 14:45:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43235 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754241Ab1JOSpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 14:45:38 -0400
Date: Sat, 15 Oct 2011 14:45:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: NeilBrown <neilb@suse.de>
cc: markgross@thegnar.org, <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <arve@android.com>,
        <amit.kucheria@linaro.org>, <farrowg@sg.ibm.com>,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        <linux-pm@lists.linux-foundation.org>, <khilman@ti.com>,
        Magnus Damm <damm@opensource.se>, <mjg@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
In-Reply-To: <20111015084732.5fe55467@notabene.brown>
Message-ID: <Pine.LNX.4.44L0.1110151435080.15129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Oct 2011, NeilBrown wrote:

> On Thu, 13 Oct 2011 11:16:23 -0400 (EDT) Alan Stern
> <stern@rowland.harvard.edu> wrote:
> 
> > On Thu, 13 Oct 2011, NeilBrown wrote:
> > 
> > > Nope, but I'm keen for you to convince me.  Identify a wakeup event that
> > > cannot be made visible to poll (or to user-space by some other
> > > mechanism) before the wakeup_source needs to be deactivated.  Or if I've
> > > misunderstood what sort of notification is problematic, help me understand.
> > 
> > Here's an example (just for kicks, not completely relevant to your
> > discussion): A USB keyboard key release.  Unlike key presses, key
> > releases need not generate input events.  If no processes are
> > monitoring the raw keyboard event queue then the release is not visible
> > to userspace at all, hence not visible before the wakeup_source needs
> > to be deactivated.
> > 
> > Alan Stern
> 
> As you say, not completely relevant.
> 
> If a tree falls in a forest with no one to here, does it make a sound?
> 
> similarly if an event happens that no-one is looking for, is it visible?
> It doesn't really matter.

That's a different question, but I'll answer it anyway: Yes, it does
matter.  If the kernel is unable to _know_ that nobody is looking for
an event, it has to _assume_ that somebody is.  Then what should happen 
if it turns out that nobody really is looking for it?

> So at most this is a case of "is not made visible" rather than "cannot be
> made visible".

In this case it's the same thing.  How can a key release be made 
visible?

> The key-release just needs to clear the "key is pressed" state so that
> auto-repeat stops and if it was a modifier, the modification is discarded.
> That is all trivially done in some kernel driver while the wakeup_source is
> active.

In other words, if the event is discarded from within the kernel then 
the wakeup_source can be deactivated at that time.  That's fine -- but 
it indicates that your original request above was phrased wrongly.  You 
should have asked for an example of a wakeup_source which the kernel 
must not deactivate without a userspace handshake, but which cannot be 
made visible by poll or some other similar mechanism.

Alan Stern

