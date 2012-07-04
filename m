Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2GDM1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:27:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54182 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2GDM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:27:38 -0400
Date: Wed, 4 Jul 2012 13:27:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120704122733.GA30698@sirena.org.uk>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
 <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF43692.2040805@nvidia.com>
X-Cookie: The other line moves faster.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 09:26:58PM +0900, Alex Courbot wrote:
> On 07/04/2012 07:48 PM, Sascha Hauer wrote:>> +

> > This looses several resources allocated earlier, like the enable gpio
> > and the pwm. This is really bad here since I have no regulator specified
> > and devm_regulator_get returns with -EPROBE_DEFER. Next time the core
> > tries to probe the driver the driver bails out because the gpio and the
> > pwm is already requested.

> That's very bad indeed. I assumed that the kernel would free
> devm-allocated resources after probe returned -EPROBE_DEFER, so that
> probe could reallocate them the next time it is called. Apparently
> that was wrong. Do you know what would the right approach be in this
> case? Does the kernel preserve the device structure and its
> associated data between the two calls to probe? If so, I could just
> check whether the private data has already been constructed to know
> which state we are in and continue from there.

I'd really expect the devm_ functions to behave as you expect - if they
don't currently we should probably fix them so that they do otherwise
we're going to be in for a lot of surprises and probe deferral becomes a
lot more cumbersome to use.
