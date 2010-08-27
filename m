Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0H0Sxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:53:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45963 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751762Ab0H0Sxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:53:34 -0400
Date: Fri, 27 Aug 2010 19:53:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Onkalo Samu <samu.p.onkalo@nokia.com>
Cc: ext Alan Cox <alan@lxorguk.ukuu.org.uk>,
        ext Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 1/3] drivers: misc: ak8974 / ami305 magnetometer driver
Message-ID: <20100827185343.GA6626@opensource.wolfsonmicro.com>
References: <1282910083-8629-1-git-send-email-samu.p.onkalo@nokia.com>
 <1282910083-8629-2-git-send-email-samu.p.onkalo@nokia.com>
 <20100827133109.1eb974ed@lxorguk.ukuu.org.uk>
 <1282928353.2194.27.camel@noppispoppis.nmp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282928353.2194.27.camel@noppispoppis.nmp.nokia.com>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 07:59:13PM +0300, Onkalo Samu wrote:
> On Fri, 2010-08-27 at 14:31 +0200, ext Alan Cox wrote:

> > > +static int ak8974_regulators_on(struct ak8974_chip *chip)
> > > +{
> > > +	int ret;
> > > +	ret = regulator_bulk_enable(ARRAY_SIZE(chip->regs), chip->regs);

> > That bit seems platform specific but in generic code ?

> If the regulator frame work is not configured, this code does nothing.
> I have understood (hopefully correctly) that if the frame work is in use
> drivers could support that directly assuming that regulators are
> configured for that platform. If that is not the case, this should be
> platform specific.

Your understanding is correct - the regulator API provides separation
between the driver and the platform so that the driver code can work
with any platform.  The driver requests supplies in terms of the
physical supplies the chip has (using the struct device and the supply
names from the datasheet).  The regulator API them matches this with
actual regulators on a given system using data provied separately by the
code specific to that machine so that the regulator and the consumer
using it don't need to know about each other.

If the regulator API is disabled then the basic regulator API calls
compile to inline stubs that report success, and there's a facility for
optionally automatically stubbing out missing supplies when the API is
enabled.
