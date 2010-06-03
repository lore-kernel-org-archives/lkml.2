Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0FCUUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:20:06 -0400
Received: from relais.videotron.ca ([24.201.245.36]:18020 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab0FCUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:20:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 03 Jun 2010 16:20:02 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Russell King <rmk@arm.linux.org.uk>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-reply-to: <20100603195703.GG25779@flint.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.1006031604380.24526@xanadu.home>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603181010.GA25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
 <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
 <20100603194559.GF25779@flint.arm.linux.org.uk>
 <1275594598.23384.52.camel@c-dwalke-linux.qualcomm.com>
 <20100603195703.GG25779@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, Russell King wrote:
> On Thu, Jun 03, 2010 at 12:49:58PM -0700, Daniel Walker wrote:
> > So your saying it would drop all the selects, but keep the selected
> > options in tact? Or it would just turn off all the selected options?
> 
> config MACH_HALIBUT
> 	bool "Halibut Board (QCT SURF7201A)"
> 	select I2C if STD_CONFIG
> 	select I2C_WHATEVER if STD_CONFIG
> 	...
> 
> That means if you enable STD_CONFIG, you'll get everything that's required
> selected.  If you then disable STD_CONFIG, I believe Kconfig leaves
> everything that was selected as still being selected.
> 
> So, what you _could_ do is start off with a blank configuration, then
> configure a kernel with STD_CONFIG enabled and you end up with everything
> that's required.  If you then want to disable something that's selected,
> turn off STD_CONFIG first, and you'll be able to turn off individual
> options.

I think this certainly makes sense, at least as a proof of concept.  If 
we end up with lots of 

	select XYZ if STD_CONFIG

then at that point it might be a good idea to introduce some variations 
in the Kconfig language directly.  Something like a multi-priority 
select statement that would either:

- provide the minimum amount of choice to the user and forcefully 
  "select" a default set of options expected to enable all features of 
  the target hardware, or

- let the user see the "preselected" options with a chance to turn it 
  off, but provide a y by default right away, or

- ignore those "preselect" statement entirely, as some expert mode.

Of course the 2nd and 3rd options wouldn't necessarily mean an optimal 
or even working kernel configuration would be produced.


Nicolas
