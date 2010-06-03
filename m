Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0FCTJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:09:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52449 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750797Ab0FCTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:09:01 -0400
Date: Thu, 3 Jun 2010 20:08:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       "Zhang, Sonic" <Sonic.Zhang@analog.com>
Subject: Re: [PATCH 1/2] regulator: new driver for the AD5398 and AD5821
Message-ID: <20100603190858.GK2762@rakim.wolfsonmicro.main>
References: <1275399239-6788-1-git-send-email-vapier@gentoo.org>
 <20100601143749.GE863@rakim.wolfsonmicro.main>
 <201006031459.53275.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006031459.53275.rgetz@blackfin.uclinux.org>
X-Cookie: In the next world, you're on your own.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:59:53PM -0400, Robin Getz wrote:
> On Tue 1 Jun 2010 10:37, Mark Brown pondered:

> > Why are the current bits and offset being suppied as platform data?  I
> > would *very* strongly expect that the location of the control in the
> > register will be fixed by the device type and should therefore be
> > figured out by the driver.  Having the machine specifying this seems
> > redundant and error prone.

> Since the parts are general purpose (their not PMU, but people use them to 
> build their own PCB defined power management system) - so it depends on the 
> PCB implementation...

Please look more closely at what's actually being done by the code here.
This is controlling the location of the bitfields in the register map.
It would be exceptionally unusal for the PCB design and layout to affect
the register map of the device at all - this will be fixed in silicon no
matter how the system is wired up.  Even without a regulator framework
there would be no need to specify where the bitfields in the register
map are located via platform data.

As far as system specific integration goes the regulator driver should
only be worrying about the properties of the chip, other parts of the
regulator API handle the board-specific setup.

> http://www.analog.com/ad5398 
> http://www.analog.com/ad5821
> are both I2C D/A Converter, with 120mA sink capability

This is not at all unusual for drivers/regulator except in that it's a
current regulator and voltage regulators are very much more common.
