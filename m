Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2ENVB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:01:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:12396 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab2ENVBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="143888427"
Date: Mon, 14 May 2012 23:11:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anton Vorontsov <cbou@mail.ru>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] mfd: wm831x: Convert to irq_domain
Message-ID: <20120514211138.GK12740@sortiz-mobl>
References: <1336943936-27999-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336943936-27999-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, May 13, 2012 at 10:18:56PM +0100, Mark Brown wrote:
> The modern idiom is to use irq_domain to allocate interrupts. This is
> useful partly to allow further infrastructure to be based on the domains
> and partly because it makes it much easier to allocate virtual interrupts
> to devices as we don't need to allocate a contiguous range of interrupt
> numbers.
> 
> Convert the wm831x driver over to this infrastructure, using a legacy
> IRQ mapping if an irq_base is specified in platform data and otherwise
> using a linear mapping, always registering the interrupts even if they
> won't ever be used. Only boards which need to use the GPIOs as
> interrupts should need to use an irq_base.
> 
> This means that we can't use the MFD irq_base management since the
> unless we're using an explicit irq_base from platform data we can't rely
> on a linear mapping of interrupts.  Instead we need to map things via
> the irq_domain - provide a conveniencem function wm831x_irq() to save a
> small amount of typing when doing so. Looking at this I couldn't clearly
> see anything the MFD core could do to make this nicer.
> 
> Since we're not supporting device tree yet there's no meaningful
> advantage if we don't do this conversion in one, the fact that the
> interrupt resources are used for repeated IP blocks makes accessor
> functions for the irq_domain more trouble to do than they're worth.
I applied this one manually, let's see which merge conflicts we get during the
merge window.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
