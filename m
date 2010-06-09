Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0FIMzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:55:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50096 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab0FIMzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:55:22 -0400
Date: Wed, 9 Jun 2010 13:55:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Vijay R. Iyengar" <Vijay.Iyengar@kpitcummins.com>
Cc: "jic23@hermes.cam.ac.uk" <jic23@hermes.cam.ac.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       David Dajun Chen <Dajun.Chen@diasemi.com>,
       "Ashish P. Chavan" <Ashish.Chavan@kpitcummins.com>,
       Nitin Shah <Nitin.Shah@kpitcummins.com>
Subject: Re: [PATCH] MFD of DA9052 Linux device drivers (1/9)
Message-ID: <20100609125518.GC7340@sirena.org.uk>
References: <F56EA673D3E56E48804FE2B0D23EFD2D217420461E@KCINPUNHJCMS01.kpit.com> <371569CBCFB2E745B891DBB88B2DFDDD19CAEABB32@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <371569CBCFB2E745B891DBB88B2DFDDD19CAEABB32@KCINPUNHJCMS01.kpit.com>
X-Cookie: Absinthe makes the tart grow fonder.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 05:04:09PM +0530, Vijay R. Iyengar wrote:

[Please fix your MUA to word wrap lines at ~80 columns.  I've reflowed
the text here]

> > These are looking pretyt touch screen specific.  What are 
> > they doing in
> > this patch?

> We have designed the EH (interrupt handler driver) and the TSI (touch
> screen driver) in a manner that the EH reads raw co-ordinates from the
> touch control registers of the DA9052 hardware in response to sampling
> ready interrupt requests and stores them in a FIFO for TSI further
> processing.

> We are implementing a common Event handler module for processing all
> the interrupt events from the DA9052 devices like battery, regulator,
> RTC etc. Fetching the TSI samples on touch events by EH rather than
> notifying the TSI driver through a call-back routine helps us to get a
> good amount of filtered touch samples from the TSI driver. 

> Hence we intend to keep the TSI raw co-ordinate reading in the event
> handling module, which is a part of the MFD driver.

The additional effort involved in pushing the interrupt notification to
the touchscreen driver is so small that it's not going to make a
meaningful difference to the performance of your driver.  I'd guess
you're already doing an equivalent amount of work managing the data
queues so I'd anticipate that the performance would be at worst
equivalent and likely better using something idiomatic (given that you
could inject the touchscreen data into the input subsystem immediately
from within interrupt context rather than having threads sitting around
in the background which need to at least be scheduled before the data is
delivered).

Obviously, if you've got benchmarking that demonstrates different
performance then I'm sure people would be interested in improving the
standard Linux stack for this.
