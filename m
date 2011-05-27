Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1E0PRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:17:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36382 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1E0PRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:17:47 -0400
Date: Fri, 27 May 2011 16:17:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joachim Holst <jocke@holstenhof.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question about MFD devices.
Message-ID: <20110527151746.GB24011@sirena.org.uk>
References: <f89af2756c3530c8b7c58a83885e5811.squirrel@oden.holstenhof.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f89af2756c3530c8b7c58a83885e5811.squirrel@oden.holstenhof.se>
X-Cookie: Stay on the trail.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 05:26:24PM +0200, Joachim Holst wrote:

> In the process, I've been trying to figure out when these MFD devices are
> supposed to be used, but I don't see the logic behind them as of yet.
> Currently it seems to me that "if a chip has more than one function, it's
> an MFD" no matter what type of functions the chip supplies.

Yes.

> To me, MFD seems to somewhat duplicate the standard kernel driver
> structure, most implementations I've seen make it rather difficult to use
> exported interfaces without integrating your driver into the structure.

Right, and MFD driver is all about sharing the resources of a chip
between the various subsystems in Linux that implement the functionality
of the chip.  This means that the various subfunctions often know quite
a bit about how the core works.

> Personally, I really don't think that a simple driver that toggles a GPIO
> X times based on an ADC value should be integrated into an MFD device
> structure. A misc device seems a bit more appropriate for this.

This doesn't seem like an MFD to me - an MFD is more about sharing the
resources on a chip than pulling things together, that sounds like
taking multiple resources on the chip and gluing them together into a
single driver.
