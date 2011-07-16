Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1GPCTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 22:19:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37173 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750849Ab1GPCTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 22:19:12 -0400
Date: Sat, 16 Jul 2011 10:47:09 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] regulator: Convert tps65023 to use regmap API
Message-ID: <20110716014536.GA17883@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1310187044-13269-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025328.GJ2927@ponder.secretlab.ca>
 <20110715044800.GK32716@opensource.wolfsonmicro.com>
 <20110715182954.GB2833@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715182954.GB2833@ponder.secretlab.ca>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 12:29:54PM -0600, Grant Likely wrote:
> On Fri, Jul 15, 2011 at 01:48:05PM +0900, Mark Brown wrote:

> > Right, the driver is always going to know exactly what bus it registered
> > on but for many drivers we don't really have any bus-specific code once
> > we factor out the register I/O.

> Exactly my point.  The only time a global registration list is needed
> is at setup time.  Once the regmap structure is initialized, it
> doesn't need to reference the list.  I far prefer the simplicity of an
> explicit bus type initialization than the implicit method with the

I'm just not seeing massive complexity here, and I am writing a lot of
multi-bus drivers with bolierplate code.  My ideal world would be one
line probe and exit functions for the buses, or better yet a single ops
structure assigned to both buses, as with my user hat on if I'm telling
the API the struct device to use I really shouldn't be having to tell it
what bus the device is on since I just told it that.

> extra indirection code needed to implement it, by my measure, ~60-70
> lines of code.

If you're talking about pure lines of code here then obviously you don't
need to convert terribly many drivers before you end up with a saving
overall.

> Also, making is explicit guarantees that there is no question about
> the i2c or spi module of regmap getting loaded before it gets used.

The bus must obviously be ready for the device to probe in the first
place and the regmap API is static only so it'll always be there.  We
just need to load the regmap hooks along with the bus core and we're
fine.

Still, the merge window is getting near so I guess I'll make the change :/
