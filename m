Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab0HaMWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:22:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48608 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754438Ab0HaMWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:22:07 -0400
Date: Tue, 31 Aug 2010 13:22:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
        Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Bengt Jonsson <bengt.jonsson@stericsson.com>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MMC: move regulator handling closer to core
Message-ID: <20100831122205.GI20849@rakim.wolfsonmicro.main>
References: <1283102159-25804-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283102159-25804-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: glibido:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 07:15:59PM +0200, Linus Walleij wrote:
> After discovering a problem in regulator reference counting I
> took Mark Brown's advice to move the reference count into the
> MMC core by making the regulator status a member of
> struct mmc_host.
> 
> I took this opportunity to also implement NULL versions of
> the regulator functions so as to rid the driver code from
> some ugly #ifdef CONFIG_REGULATOR clauses.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

A few small comments below.

> +		if (host->vcc) {
> +			ret = mmc_regulator_set_ocr(mmc, host->vcc, ios->vdd);
> +			if (ret)
> +				dev_err(mmc_dev(mmc),
> +					"could not set regulator OCR\n");
> +		}

It'd be nice to display the error code as well.  I do tend to agree with
Adrian that it might be nice to have the noop functions in the header to
allow the optimiser to play with them as well but it's unlikely to be a
big deal.
