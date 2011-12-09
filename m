Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1LIOPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:15:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36752 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1LIOPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:15:20 -0500
Date: Fri, 9 Dec 2011 15:15:12 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>, kernel@pengutronix.de,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] pinctrl: add a driver for Energy Micro's efm32 SoCs
Message-ID: <20111209141512.GU4585@pengutronix.de>
References: <1323384057-31452-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <4693507.K6tP4YDUh2@wuerfel>
 <20111209092300.GR4585@pengutronix.de>
 <201112091355.16720.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201112091355.16720.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 01:55:16PM +0000, Arnd Bergmann wrote:
> On Friday 09 December 2011, Uwe Kleine-König wrote:
> > On Thu, Dec 08, 2011 at 11:55:53PM +0100, Arnd Bergmann wrote:
> > > On Thursday 08 December 2011 23:40:57 Uwe Kleine-König wrote:
> > > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > ---
> > > > Note that there is no support yet for efm32 in mainline, so ARCH_EFM32
> > > > isn't defined.
> > > 
> > > Since the platform is not yet part of the architecture, it will have
> > > to use device tree based probing when it gets added. I would suggest
> > > only merging drivers for it that can deal with this and do not rely
> > > on platform_data.
> >
> > I feared you will say that. These machines have at most 4MiB of RAM.
> > I'll have to evaluate if dt is too heavy for them.
> 
> What's the state of the platform code? Is this based on Catalin's
> Cortex-M3 tree? I've heard a few people express interest in getting
> various M3 based SoCs supported mainline and I think that would
> be a good idea, but I would also expect that device tree is one
> of the lesser problems here.
Yes, I took a few patches from there and rebased them to 3.2-rc3. The
patches I have from Catalin are:

131dbba Cortex-M3: Add base support for Cortex-M3
48cc6a8 Cortex-M3: Add support for exception handling
2aebf66 Cortex-M3: Add NVIC support
75bf249 Cortex-M3: Allow the building of Cortex-M3 kernel port
66dcc1e Cortex-M3: Add VFP support
a541241 [ARM] Do not call flush_cache_user_range with mmap_sem held
6083ea7 ARM: Handle instruction cache maintenance fault properly

I didn't look into these deeply yet to check how ready they are for
mainline, but my machine boots to a prompt (which doesn't allow to start
anything because it doesn't have enough memory to allocate the stack for
a new program. I will soon get a machine that has 4MiB of RAM instead of
the 1MiB I have now).

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
