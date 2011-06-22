Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab1FVWsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:48:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34429 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757938Ab1FVWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:48:35 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18p9rVQHzop5pyyCdYhapOweqllZg8TzVC7hxnIp6
	0+BtueeYDFdDY6
Date: Thu, 23 Jun 2011 00:48:28 +0200
From: torbenh <torbenh@gmx.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 0/8] Generic I2C and SPI register map library
Message-ID: <20110622224828.GA2342@siel.b>
Mail-Followup-To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org,
	Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Graeme Gregory <gg@slimlogic.co.uk>
References: <20110622184407.GC13847@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622184407.GC13847@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 07:44:08PM +0100, Mark Brown wrote:
> [This reposting of the series should address all the review comments on
> the series so far.]
> 
> Many I2C and SPI based devices implement register maps on top of the raw
> wire interface.  This is generally done in a very standard fashion by
> devices, resulting in a lot of very similar code in drivers.  For some
> time now ASoC has factored this code out into the subsystem but that's
> only useful for audio devices.  The intention with this series is to
> generalise the concept so that it can be used throughout the kernel.
> 
> It's not intended that this be suitable for all devices - some devices
> have things that are hard to generalise like registers with variable
> size and paging which are hard to support genericly.  At the minute the
> code is focused on the common cases.  It is likely that the same code
> could be used with other buses with similar properties to I2C and SPI.

you should look at SMBus 
there seems to be quite some code to share.
in particular i2c rtc devices seem to be using SMBus functions
to get the exact same semantics you are providing here.

I just added support for such a device today, and it struck me, that
this API was necessary.

i did not look into it very deeply. and still dont really understand the
diff between SMBus and i2c...





> 
> Currently only physical I/O is handled, the intention is that once this
> support has been reviewed and merged the generic register cache code
> that ASoC includes will also be factored out too.  For devices with read
> heavy workloads (especially those that need a lot of read/modify/write
> cycles) or which don't support read at all this can provide a useful
> performance improvement and for sparse register maps there's a lot of
> benefit in relatively complex cache code.

hopefully, the caching can be selective.
keep rtcs in mind. huge potential for throwing code away there ;)


-- 
torben Hohn
