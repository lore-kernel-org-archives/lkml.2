Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab1HBBvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:51:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58013 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753605Ab1HBBvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:51:03 -0400
Date: Tue, 2 Aug 2011 10:50:53 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tabi Timur-B04825 <B04825@freescale.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/misc: introduce Freescale Data Collection
 Manager driver
Message-ID: <20110802015050.GA17286@opensource.wolfsonmicro.com>
References: <1312235334-15036-1-git-send-email-timur@freescale.com>
 <20110801234645.GA15792@sirena.org.uk>
 <4E373D88.80006@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E373D88.80006@freescale.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 11:58:00PM +0000, Tabi Timur-B04825 wrote:
> Mark Brown wrote:
> > On Mon, Aug 01, 2011 at 04:48:54PM -0500, Timur Tabi wrote:

> >> PowerPC reference boards that can read temperature, current, and voltage
> >> settings from the sensors on those boards.  This driver exposes the DCM via a
> >> sysfs interface (/sys/devices/platform/fsl-ocm.0).

> > This sounds like it should be a hwmon driver.

> I didn't see any way to interface the hardware to the hwmon layer in a 
> manner that provides the information that our customers went using this 
> hardware.

Even if that's the case I can't see that it is a good reason for adding
a driver out of any subsystem with a completely non-standard interface.

> > Though this is a bit odd for the subsystem I don't think it's too far
> > out of what other hwmon chips can do, some of them do have longer term
> > stats than just instantaneous readings.

> Can you show an example or some documentation?  I couldn't find anything 
> remotely like that.  I don't even see anything that lets me start/stop 
> monitoring of sensors.

I'd expect that things like the _lowest, _highest and _average
attributes which a number of drivers have are what you're looking for.
At the very least it seems obvious how you might extend the interface if
some features you need are missing.  The subsystem has fairly extensive
documentation in Documentation/hwmon.
