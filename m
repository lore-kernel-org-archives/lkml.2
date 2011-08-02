Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1HBC1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 22:27:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52002 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753206Ab1HBC1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 22:27:06 -0400
Date: Tue, 2 Aug 2011 11:26:59 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/misc: introduce Freescale Data Collection
 Manager driver
Message-ID: <20110802022655.GA11282@opensource.wolfsonmicro.com>
References: <1312235334-15036-1-git-send-email-timur@freescale.com>
 <20110801234645.GA15792@sirena.org.uk>
 <4E373D88.80006@freescale.com>
 <20110802015050.GA17286@opensource.wolfsonmicro.com>
 <4E375998.1020901@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E375998.1020901@freescale.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 01:57:45AM +0000, Tabi Timur-B04825 wrote:
> Mark Brown wrote:

> > I'd expect that things like the _lowest, _highest and _average
> > attributes which a number of drivers have are what you're looking for.

> Yes, but then all I'm doing is presenting numbers that don't change to an 
> interface, simply on the basis that the numbers represent sensor values.

> If I'm running a sensor application, I'm doing it to get real-time 
> monitoring of the sensors in my system.  The DCM on our boards is not 
> capable of real-time results.  So you're not actually "monitoring" the 
> hardware.  The data from the DCM is available only *after* you stop 
> running the background process.

Right, that seems to fit reasonably well with things like averages and
extremes.

> > At the very least it seems obvious how you might extend the interface if
> > some features you need are missing.  The subsystem has fairly extensive
> > documentation in Documentation/hwmon.

> I just don't see how it fits.  Yes, I could do it, but then I'd end up 
> with something that doesn't make any sense.  I would have to use a custom 
> interface to start monitoring and then another interface to stop it.  Then 

The most obvious thing seems to be to use the existing _reset_history
stuff to trigger a restart.  If the hardware is so incapable that it
can't cope with reads while active and needs to be reset to even pause
that's seems pretty rubbish, I'd have expected you could at least pause
measurement momentarily to do a read.

Perhaps integration as a PMU may make more sense?  The general point
here is that this doesn't sound like it's doing something so odd that it
shouldn't even be trying to work within any sort of framework.
