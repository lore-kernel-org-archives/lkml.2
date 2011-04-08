Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1DHPKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:10:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48133 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757204Ab1DHPKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:10:37 -0400
Date: Fri, 8 Apr 2011 11:10:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Endless loop with "detected XactErr"
In-Reply-To: <BANLkTikj+=J3m7+1cOVHHcDqSCY7XeoCrw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104081100250.1992-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Zdenek Kabelac wrote:

> >> Just with changing last number - I've got only one such line on serial console.
> >> By looking into  "drivers/usb/host/ehci-q.c"  - there seems to be
> >> endless goto loop.
> >
> > It isn't endless.  You didn't notice the test against QH_XACTERR_MAX.
> >
> 
> Maybe I've not been patient enough - but I'd been waiting for quite some time
> and the console was just scrolling this line on display - so I need to
> turn-off the machine.
> (After like a minute of this looping)

This is because the loop ends and then starts again (you can tell 
because the retry counter goes back to 1).

> > This particular error message indicates a hardware problem in the USB
> > signals.  A bad contact, a bad cable, a device failure -- something
> > like that.
> 
> Well it's been connected to Lenovo docking station - so unsure what
> bad cable you mean here.
> (and AFAICT it seems to work quite well all the time).

It doesn't have to be a bad cable.  It could be any sort of hardware 
failure.  Perhaps the docking or undocking operation itself messes 
something up.

> >> Here is the trace from last resume:
> >
> >> [  473.873802] ACPI: \_SB_.GDCK - undocking
> >> [  473.897678] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0010
> >> [  473.904809] ehci_hcd 0000:00:1a.7: detected XactErr len 0/4 retry 1
> >
> > And presumably additional lines containing similar messages.
> >
> > There's no real reason for them ever to stop, since they are only
> > debugging messages.  If you turn off CONFIG_USB_DEBUG you'll never see
> > tham.
> 
> 
> You mean it's normal I get machine stuck in endless loop when I turn
> on debugging ?

Are you really sure the machine is stuck?  If you disable 
CONFIG_USB_DEBUG, does it hang or can you still get useful work done?

> I though debug is there to debug the problem - not to add a new one ??

It doesn't add any problems, since you can always turn the debugging 
off.  And the messages do aid in debugging -- if they weren't present, 
you would not have been aware of the problem.

> As this happened during suspend - I had no other option than to simply
> turn off the machine.

It doesn't appear that way in the log you posted.  The resume completed
at timestamp 467.8, and the debugging messages didn't start until 6
seconds later.

You might want to track down the original source of the 
underlying error.  Since the machine was docked the entire time, the 
line saying:

[ ï¿½473.873802] ACPI: \_SB_.GDCK - undocking

definitely looks suspicious.  I bet if you can fix that then the USB 
problems will go away.

Alan Stern

