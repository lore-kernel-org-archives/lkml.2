Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2FFSHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:07:44 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45173 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2FFSHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:07:42 -0400
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Khalid Aziz <khalid.aziz@hp.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20120606174202.GA8750@srcf.ucam.org>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	 <20120606135009.GB1517@srcf.ucam.org> <1338999463.25761.630.camel@lyra>
	 <20120606162703.GA6779@srcf.ucam.org> <1339003956.25761.667.camel@lyra>
	 <20120606174202.GA8750@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jun 2012 12:07:40 -0600
Message-ID: <1339006060.25761.689.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 18:42 +0100, Matthew Garrett wrote:
> On Wed, Jun 06, 2012 at 11:32:36AM -0600, Khalid Aziz wrote:
> 
> > Do we agree that if device shutdown routine cleanly shuts down all I/O,
> > clearing PCI Bus Mster bit should be safe?
> 
> In the absence of hardware that dislikes the bus master bit ever being 
> disabled, yes. Do we know if hardware is ever tested in that situation?

I will wait for device vendors to comment on that. I can't claim I have
tested more than a few devices that way.

> 
> > If yes, then we only have to deal with broken devices. So the approach 
> > could be to disable Bus Master bit unless the device ID matches a 
> > blacklist which we update as we find broken devices. I really don't 
> > like the idea of maintaining blacklists in the kernel for such things 
> > but is that a more practical approach? If blacklist does not sound 
> > good, maybe we can ask drivers to tell PCI subsystem if they are not 
> > ok with clearing Bus Master bit and then PCI subsystem could skip 
> > those devices.
> 
> Or we could just put responsibility on the drivers to ensure that the 
> hardware won't continue doing any DMA, either by shutting down the 
> engines or clearing the bit.
> 

I assume device shutdown routine should stop all I/O and shutting down
DMA engine. Disabling Bus Master bit is just an extra measure of safety.
I do like the idea of disabling Bus Master bit in device shutdown
routine. After all, drivers know their hardware best. On the other hand,
it is change to lots of driver code to implement this which means it
will end up happening slowly over period of time. I don't mind doing the
work up front on a good number of drivers I feel comfortable modifying.
I am ok with pulling out code to clear bus master bit from PCI subsystem
and replacing it with modified shutdown routines for a few drivers to
start with.

Does any one see any other issues with modifying driver shutdown
routines for disabling Bus Master bit? Bjorn, any opinions?

====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

