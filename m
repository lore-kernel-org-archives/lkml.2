Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1GZNd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 09:33:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36424 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1GZNdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 09:33:24 -0400
Date: Tue, 26 Jul 2011 08:33:17 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb_storage: make usb-stor-scan task non-freezable
Message-ID: <20110726133317.GB6687@thinkpad-t410>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
References: <20110723210805.GA25113@thinkpad-t410>
 <Pine.LNX.4.44L0.1107232150380.27037-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107232150380.27037-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 09:56:15PM -0400, Alan Stern wrote:
> On Sat, 23 Jul 2011, Seth Forshee wrote:
> 
> > After experimenting with this device more I came to the conclusion that
> > the normal behavior with this machine is for the card reader to be
> > disconnected from the USB bus unless there's a card in the slot. During
> > a normal boot with an empty card slot the card reader never shows up on
> > the bus.
> 
> Weird.  Then the reader would never be usable.  Unless it connects 
> itself to the bus when a card is inserted?

Yes, the reader is connected to the bus when a card is inserted. Remove
the card and it disappears again.

> > The only solution I've come up with is to leave usb-stor-scan freezable
> > without allowing it to actually freeze. We can request a fake signal be
> > sent when freezing and use interruptible sleep to abort the wait early
> > and finish up the thread's processing. This is implemented in the patch
> > below. Does this approach look reasonable? It's rather subtle, but it
> > does seem to work. I done numerous S4 cycles with and without a card
> > inserted and didn't get any failures.
> 
> This runs the risk of failing to suspend if scanning takes too long.  

It may increase the exposure to that risk, but really the risk is
already there.

> On the other hand, many systems nowadays use async scanning anyway.
> And that combination of events isn't too likely to happen, whereas 
> you're facing a real problem right now.  So I guess this is okay.

Great, thanks.

Will the patch get picked up from my previous email, or do I need to
resend it?

Thanks,
Seth
