Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1JXBSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 21:18:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60169 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1JXBSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 21:18:10 -0400
Date: Sun, 23 Oct 2011 18:18:04 -0700
From: mark gross <markgross@thegnar.org>
To: NeilBrown <neilb@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, markgross@thegnar.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111024011804.GB12215@mgross-G62>
Reply-To: markgross@thegnar.org
References: <20111016092556.07d6e415@notabene.brown>
 <Pine.LNX.4.44L0.1110152136460.19724-100000@netrider.rowland.org>
 <20111017083717.0bd5626c@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017083717.0bd5626c@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for going AWOL on this thread.  I had some biz travel and fires to
fight.

On Mon, Oct 17, 2011 at 08:37:17AM +1100, NeilBrown wrote:
> On Sat, 15 Oct 2011 21:49:44 -0400 (EDT) Alan Stern
> <stern@rowland.harvard.edu> wrote:
> 
> 
> > All right, let's make things a little more complicated.
> 
> Let's call it "realistic".   It is good to have some realism to make sure our
> abstract discussions actually mean something.
> 
> > 
> > Here's what actually happens when a USB keyboard generates a wakeup 
> > request.  The system wakes up, of course, but there's no particular 
> > indication of the cause.  In particular, the usbhid driver has no way 
> > to know directly that the keyboard was the reason for the wakeup.
> > 
> > In addition, usbhid can't poll keyboards to see if they have an event
> > to report.  (In theory it could -- the HID protocol allows for this --
> > but many keyboards don't support that part of the protocol properly.)  
> > It has to wait until the keyboard gets around to reporting the event, 
> > which can take 10 ms or more.
> > 
> > Taken together, this means usbhid must activate a wakeup_source every
> > time it wakes up.  If a keyboard event report is received reasonably
> > quickly then good, it can deactivate the wakeup_source at the right
> > time.  But if not, all the driver can do is time out the wakeup_source
> > after some delay.  I don't see any way to avoid it.
> 
> I have to agree with you there.
> This is similar to Rafael's example of a Wake-on-LAN packet arriving.  At
> that point there is nothing you can do except wait a little while expecting
> more information.
> 
> You could see this as a case where the wake-up event isn't even visible to
> the kernel, so there is obviously no way to make it visible to user-space.
> 
> Or you could see it as a wake-up event that is expected to be delivered over
> a long period of time (many msecs).  The kernel gathers the wake-up event,
> makes it visible to user-space (once it actually arrives), and then releases
> the wakeup_source.
> 
> So it is a good example and highlights the difficulty of defining exactly
> what a wake-up event it, and of what it means to be "visible".
> 
> I think it still fits in your rephrasing of my question which - if I rephrase
> it as a requirement - is roughly,
> 
>   A wakeup-event that needs to be handled by user-space must be visible to
>   user-space before the driver deactivates the wakeup_source.
> 
> A requirement which, in this case, means the driver needs to hold  the
> wakeup_source for an extended time using a timeout, just as you say.

Timeout?  why can't we define a proper notification handshake for such
things?  Timeouts are never right IMO.

--mark



> Thanks,
> NeilBrown


