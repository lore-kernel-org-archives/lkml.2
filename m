Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab1IGScg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:32:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55652 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756425Ab1IGScf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:32:35 -0400
Date: Wed, 7 Sep 2011 11:32:31 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, Michael.Hennerich@analog.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 2/6] regmap: Add a magic bus type to handle quirks of
 analog devices ADIS sensors.
Message-ID: <20110907183230.GA4423@opensource.wolfsonmicro.com>
References: <4E679770.4090008@cam.ac.uk>
 <1315412387-5765-3-git-send-email-jic23@cam.ac.uk>
 <20110907174713.GG2906@opensource.wolfsonmicro.com>
 <4E67B742.6030302@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E67B742.6030302@cam.ac.uk>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 07:26:10PM +0100, Jonathan Cameron wrote:
> On 09/07/11 18:47, Mark Brown wrote:
> > On Wed, Sep 07, 2011 at 05:19:43PM +0100, Jonathan Cameron wrote:

> > To be honest I'm not terribly happy about
> > pushing this into the regmap core code; if we start needing to do stuff
> > like this we should expose the bus interface.

> That's certainly an option, but I'd really like to use the regmap caching
> stuff in here.  These things can have quite a few registers that other than
> their weird read / write quirks look much like any other register based
> device. (particularly ignoring the burst reads but they tend to apply
> to volatile registers only so caching is probably irrelevant).

> At the moment, the only hooks AFAIKS to allow this are at the bus level.
> I'm not sure where else they could go. (I haven't actually looked much
> at the cache code yet though).

Well, if there's not hooks they could be added if it's not too painful.
However I'm not convinced that's sane.

> Actually I may have misunderstood, do you mean expose the bus interface
> within regmap or just not use regmap at all?

Either.  Or either expose marshalling or add configuration for the
marshalling depending on what's being done, I'm not convinced you need
to be working at SPI level at all.

> >> +static struct regmap_bus regmap_spi_adi = {
> >> +	.write = regmap_spi_write,
> >> +	.read = regmap_spi_read,
> >> +};

> > You want to implement the gather write too if you can.

> Doesn't really exist other than by linearising them into a series
> of calls to the write function. (assuming I understand what those
> functions are doing right!)

If you build up a series of SPI transfers you just need to control when
/CS gets bounced appropriately.
