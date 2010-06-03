Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0FCTAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:00:00 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:55426 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0FCS76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:59:58 -0400
Cc: Mike Frysinger <vapier@gentoo.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.53,355,1272859200"; 
   d="scan'208";a="17466837"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Analog Devices, Inc.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/2] regulator: new driver for the AD5398 and AD5821
Date: Thu, 3 Jun 2010 14:59:53 -0400
User-Agent: KMail/1.9.5
References: <1275399239-6788-1-git-send-email-vapier@gentoo.org> <20100601143749.GE863@rakim.wolfsonmicro.main>
In-Reply-To: <20100601143749.GE863@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201006031459.53275.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 1 Jun 2010 10:37, Mark Brown pondered:
> On Tue, Jun 01, 2010 at 09:33:58AM -0400, Mike Frysinger wrote:
> > From: Sonic Zhang <sonic.zhang@analog.com>
> 
> > This driver supports both the AD5398 and the AD5821.  It adapts into the
> > voltage and current framework.  The generic userspace-consumer and virtual
> 
> Might be useful to put something here saying what these chips do...

[snip]

> > +/**
> > + * ad5398_platform_data - platform data for ad5398
> > + * @current_bits: effective bits in register
> > + * @current_offset: offset of effective bits in register
> > + * @ad5398_init_data: regulator init data
> > + */
> > +struct ad5398_platform_data {
> > +	unsigned short current_bits;
> > +	unsigned short current_offset;
> > +	struct regulator_init_data *regulator_data;
> > +};
> 
> Why are the current bits and offset being suppied as platform data?  I
> would *very* strongly expect that the location of the control in the
> register will be fixed by the device type and should therefore be
> figured out by the driver.  Having the machine specifying this seems
> redundant and error prone.

Since the parts are general purpose (their not PMU, but people use them to 
build their own PCB defined power management system) - so it depends on the 
PCB implementation...

http://www.analog.com/ad5398 
http://www.analog.com/ad5821
are both I2C D/A Converter, with 120mA sink capability

-Robin
