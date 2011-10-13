Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1JMPGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:06:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59255 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755620Ab1JMPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:06:36 -0400
Date: Thu, 13 Oct 2011 11:06:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: mark gross <markgross@thegnar.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, NeilBrown <neilb@suse.de>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        <arve@android.com>, <amit.kucheria@linaro.org>, <farrowg@sg.ibm.com>,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        <linux-pm@lists.linux-foundation.org>, <khilman@ti.com>,
        Magnus Damm <damm@opensource.se>, <mjg@redhat.com>,
        <peterz@infradead.org>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
In-Reply-To: <20111013030742.GB893@mgross-G62>
Message-ID: <Pine.LNX.4.44L0.1110131101420.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, mark gross wrote:

> > > > sometimes devices that are not wake up sources need critical sections
> > > > where suspend is a problem.
> > 
> > Mark, can you give some examples?  This isn't the same as the firmware 
> > update thing, is it?  That deserves to be handled by a completely 
> > separate mechanism.
> 
> The biggest example I know of is any usb gadget implementation while
> connected to a USB host.  If the device is connected to the USB bus then
> it needs to not suspend because it cannot respond to the USB commands
> for bus power.  i.e. if its connected to a laptop and the suspend the
> laptop the gadget needs to handle the USB protocol packets.
> 
> Also, when charging battery under OS control we don't want to suspend
> because it will be hard to respond to thermal events  or changing
> battery conditions if the system is in suspend.

This is like the firmware update problem -- it has nothing to do with 
wakeups.  It could be handled very easily either by abusing a wakeup 
source as Neil suggested or by adding a different mechanism for 
preventing system sleeps.

> > Although many of these problems could be solved by adopting a suitable
> > protocol in userspace, currently there is no such protocol.  Even if
> > one did exist, the process of getting all the relevant programs to
> > adopt it would take quite a while.  This is a case where a problem can
> > be solved either in the kernel or in userspace, and the in-kernel
> > solution may be simpler.
> 
> I do think a better solution would involve some kernel coordination.
> 
> I don't want to split hairs on if its 100% possible to implement a
> correct solution only in user mode.  but, I think there are corner cases
> that may be hard or impossible to get right with only user mode.  See
> gadget issue above.  Not all gadgets have a user mode daemon backing up
> the kernel part do they?

I don't know.  But if they don't have some sort of userspace component
for power management then they never go into suspend, because the
kernel doesn't initiate suspends by itself.

Alan Stern

