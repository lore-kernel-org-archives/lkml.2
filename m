Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1FUPGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:06:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59033 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756752Ab1FUPGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:06:37 -0400
Date: Tue, 21 Jun 2011 11:06:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Pitre <nico@fluxnic.net>
cc: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>, <linux-usb@vger.kernel.org>,
        <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing
 the packed attribute
In-Reply-To: <alpine.LFD.2.00.1106201653450.2142@xanadu.home>
Message-ID: <Pine.LNX.4.44L0.1106211058250.2327-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Nicolas Pitre wrote:

> On Mon, 20 Jun 2011, Alan Stern wrote:
> 
> > On Mon, 20 Jun 2011, Nicolas Pitre wrote:
> > 
> > > > As far as I can tell, the other structures in ehci.h have 
> > > > ((aligned(32)) simply in order to save space, since there can be large 
> > > > numbers of these structures allocated.
> > > 
> > > How can increasing the alignment to 32 bytes save space?
> > 
> > No, no -- the alignment is _decreased_ to 32 bits.  Without the 
> > attribute the alignment would have been 64 bits.
> 
> The aligned attribute requires a byte value not a bit value.
> Maybe what you meant is ((aligned(4)) ?

Ah, very good point!  No, I meant ((aligned(32))).  Do "grep aligned 
drivers/usb/host/ehci.h" and you'll see.

So my understanding was wrong; these structure really are being forced 
to a strict alignment.  And indeed, now that I go back and look at the 
EHCI spec, it turns out that this alignment is required by the 
hardware.

Okay, so this digression was irrelevant to our discussion.  Forget I 
mentioned it...

Alan Stern

