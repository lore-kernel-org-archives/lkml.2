Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1FTRLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 13:11:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45074 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1FTRK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 13:10:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 13:10:50 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Alexander Holler <holler@ahsoftware.de>, linux-usb@vger.kernel.org,
        gregkh@suse.de, lkml <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the
 packed attribute
In-reply-to: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
Message-id: <alpine.LFD.2.00.1106201306210.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Alan Stern wrote:

> On Mon, 20 Jun 2011, Nicolas Pitre wrote:
> 
> > On Mon, 20 Jun 2011, Alan Stern wrote:
> > 
> > > On Sun, 19 Jun 2011, Nicolas Pitre wrote:
> > > 
> > > > > > The question is: does the structure really has to be packed?
> > > > > 
> > > > > What do you mean?  The structure really does need to be allocated
> > > > > without padding between the fields; is that the same thing?  So do a
> > > > > bunch of other structures that currently have no annotations at all.
> > > > 
> > > > Yes, that's the same thing.  The packed attribute tells the compiler 
> > > > that you don't want it to insert padding in it as it sees fit.
> > > 
> > > I thought the packed attribute does more than that.  For example, on
> > > some architectures doesn't it also force the compiler to use
> > > byte-oriented instructions for accessing the structure's fields?
> > 
> > Yes, but that's a consequence of not being able to access those fields 
> > in their naturally aligned position anymore.  Hence the addition of the 
> > align attribute to tell the compiler that we know that the structure is 
> > still aligned to a certain degree letting the compiler to avoid 
> > byte-oriented instructions when possible.
> 
> Not exactly.  As far as I can tell, the ((packed)) attribute caused the 
> compiler to change the structure's alignment from its natural value to 
> 1.  That's why the fields weren't in their naturally aligned positions 
> and why removing ((packed)) fixed the problem.

Are we talking past each other?

Remember that I was the one asking if the align attribute was needed in 
the first place.  If it is not then by all means please get rid of it!

But if it _is_ needed, then the generated code can be much better if the 
packed attribute is _also_ followed by the align attribute to 
increase it from 1.


Nicolas
