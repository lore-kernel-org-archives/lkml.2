Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab1FWKfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:35:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48589 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759029Ab1FWKfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:35:05 -0400
Date: Thu, 23 Jun 2011 11:35:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: Add I2C control support for S5M8751
Message-ID: <20110623103502.GA21932@opensource.wolfsonmicro.com>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-4-git-send-email-sbkim73@samsung.com>
 <20110622125050.GE23666@sirena.org.uk>
 <017201cc3144$74e343d0$5ea9cb70$@com>
 <20110623012841.GF20949@opensource.wolfsonmicro.com>
 <017301cc314c$37839eb0$a68adc10$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <017301cc314c$37839eb0$a68adc10$@com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 11:21:10AM +0900, Sangbeom Kim wrote:
> On Thu, Jun 23, 2011 at 10:29 AM +0900, Mark Brown wrote:

> > In that case you should definitely take a look at the regmap API I've
> > been posting.  It factors all the device I/O stuff out so you should be
> > able to just tell it that you have a device with n bit registers and n
> > bit values and it'll provide all the I/O functions you need.  I just
> > reposted it today, though it needs another round for some SPI stuff.

> OK, After reviewing your patch, I will apply  it.

Note that it's not actually in mainline yet, it's still being reviewed.

> > > > > +	*val = (uint8_t)ret;

> > > > Why is this case required?

> > > I want pass the read value by val

> > Sorry, typo - why is this *cast* required?

> Just want to make same type.

Usually unless there's a reason to do a cast it's better to let the
compiler figure things out as a cast can stop the toolchain identifying
real issues for you.
