Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0JMPfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:35:10 -0400
Received: from mail.perches.com ([173.55.12.10]:2876 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab0JMPfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:35:09 -0400
Subject: Re: [PATCH] sound/soc: rename vol to volatile_register as
 appropriate
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
In-Reply-To: <20101013152916.GA20270@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
	 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
	 <1286934472.1117.129.camel@Joe-Laptop>
	 <20101013082414.GD6424@rakim.wolfsonmicro.main>
	 <1286971846.1117.191.camel@Joe-Laptop>
	 <20101013123301.GL6424@rakim.wolfsonmicro.main>
	 <1286974549.1117.254.camel@Joe-Laptop>
	 <20101013151117.GM6424@rakim.wolfsonmicro.main>
	 <1286983667.1117.347.camel@Joe-Laptop>
	 <20101013152916.GA20270@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 08:35:07 -0700
Message-ID: <1286984107.1117.361.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 16:29 +0100, Mark Brown wrote:
> On Wed, Oct 13, 2010 at 08:27:47AM -0700, Joe Perches wrote:
> > On Wed, 2010-10-13 at 16:11 +0100, Mark Brown wrote:
> > > If you check the code again you will notice that these functons are all
> > > used in ops structures which presents obvious issues when trying to
> > > replace with open coded checks.
> > > I hope their usefulness is clear given the above.
> > There is some value in using consistent
> > function styles for table driven and non-table
> > driven instances.
> I'm sorry, I don't understand what you are saying here.  What do you
> believe to be inconsistent?

I don't believe anything to be inconsistent about
the volatile uses and was agreeing with you.

Some codecs functions for volatile access use
a switch/case,

static int wm8994_volatile(unsigned int reg)
{
	if (reg >= WM8994_REG_CACHE_SIZE)
		return 1;

	switch (reg) {
	case WM8994_SOFTWARE_RESET:
	case WM8994_CHIP_REVISION:
	case WM8994_DC_SERVO_1:
	case WM8994_DC_SERVO_READBACK:
	case WM8994_RATE_STATUS:
	case WM8994_LDO_1:
	case WM8994_LDO_2:
		return 1;
	default:
		return 0;
	}
}

others use the register variable from the struct

static int wm8962_volatile_register(unsigned int reg)
{
	if (wm8962_reg_access[reg].volatile_register)
		return 1;
	else
		return 0;
}

so I'm agreeing that it's useful to keep the
same access style in multiple codecs instead
of using separate styles in each one.

It'd be even better to use a similarly consistent
function naming scheme.

cheers, Joe

