Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1FCRSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:18:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40590 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750990Ab1FCRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:18:40 -0400
Date: Fri, 3 Jun 2011 18:18:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Dmitry Artamonow <mad_soft@inbox.ru>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: [PATCH] gpio: add GPIOF_ values regardless on kconfig settings
Message-ID: <20110603171837.GA9918@opensource.wolfsonmicro.com>
References: <20110523155343.2e68c265.randy.dunlap@oracle.com>
 <20110524000837.GA30515@opensource.wolfsonmicro.com>
 <4DDB082F.3010107@oracle.com>
 <20110524014959.GA27710@opensource.wolfsonmicro.com>
 <4DDB3AFF.9030006@oracle.com>
 <20110524075248.GB19734@sirena.org.uk>
 <20110527074552.GA907@ponder.secretlab.ca>
 <4DDFE391.2030507@oracle.com>
 <20110527201201.GA6645@ponder.secretlab.ca>
 <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin-KSVcG2cQfRM3Ys0_g_uJVruDMw@mail.gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 11:04:52AM -0600, Grant Likely wrote:

> I ended up not pushing this one to Linus.  Turns out it causes other
> breakage on other platforms that don't include include/linux/gpio.h.
> Since I don't have confidence that I'll be able to find all the
> offenders, I'm dropping it.  I recommend making any drivers that are

So, this originally came about because I pushed back on adding random
dependencies like this for features which are pretty much optional in
drivers - their use of GPIOs is totally optional and the dependencies
are just too fragile, leading to noise with all the randconfigs.  It
seems better to get the architectures to keep up with enhancements to
gpiolib (or convert to it) than to have to worry about this in drivers.

> breaking on these symbols depend on GPIOLIB.  Platforms not using
> gpiolib are strongly discouraged now anyways, and there only a handful
> of files in drivers/ that reference GPIOF_*.

That's more a result of it being a pretty new feature than anything else
I think.
