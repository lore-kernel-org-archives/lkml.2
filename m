Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0JMPLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:11:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48549 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858Ab0JMPLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:11:23 -0400
Date: Wed, 13 Oct 2010 16:11:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] sound/soc: rename vol to volatile_register as
 appropriate
Message-ID: <20101013151117.GM6424@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
 <1286934472.1117.129.camel@Joe-Laptop>
 <20101013082414.GD6424@rakim.wolfsonmicro.main>
 <1286971846.1117.191.camel@Joe-Laptop>
 <20101013123301.GL6424@rakim.wolfsonmicro.main>
 <1286974549.1117.254.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286974549.1117.254.camel@Joe-Laptop>
X-Cookie: 667:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 05:55:48AM -0700, Joe Perches wrote:
> On Wed, 2010-10-13 at 13:33 +0100, Mark Brown wrote:

> > Are any of the contexts actually ambiguous?  I have to say I don't find
> > this useful.  If the register I/O code knows anything about volumes I'd
> > say we've probably messed up somewhere.

> Looking at the 2 register access routines where
> volatile_register/vol is used, I'd say those
> routines aren't useful at all and the checks
> should be inline instead.

If you check the code again you will notice that these functons are all
used in ops structures which presents obvious issues when trying to
replace with open coded checks.  If we remove these functions then the
core won't be able to tell if it should read registers from the hardware
or from the cache.

> This sort of wrapper routine doesn't serve
> much of a purpose to me:

>  static int wm8904_volatile_register(unsigned int reg)

I hope their usefulness is clear given the above.

> > It's used as the field name for volatility in all the
> > drivers I can remember that use a table to look volatility up in
> > register properties.

> I did a grep for vol in sound, I found the uses
> where it was for volatile and patched them.

> Are there others?  Perhaps, but I don't think so.
> Probably not in sound.  Was there some other
> subsystem you meant?  Maybe you have examples
> I missed?

You're missing the "for this" here, I believe.  To reiterate what I said
originally as far as I can remember every ASoC driver which uses a table
to look up volatility uses this naming.
