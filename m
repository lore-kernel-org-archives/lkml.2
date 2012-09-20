Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2ITTEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:04:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56243 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2ITTEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:04:05 -0400
Date: Thu, 20 Sep 2012 20:03:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Beno??t Th??baudeau <benoit.thebaudeau@advansee.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm: Call pwm_enable() before pwm_config()
Message-ID: <20120920190342.GA13264@sirena.org.uk>
References: <36966374.2768747.1345741025741.JavaMail.root@advansee.com>
 <50366464.4070801@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50366464.4070801@metafoo.de>
X-Cookie: Use extra care when cleaning on stairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 07:12:04PM +0200, Lars-Peter Clausen wrote:
> On 08/23/2012 06:57 PM, Beno??t Th??baudeau wrote:

> > exists with several other PWM drivers.

> Since this seems to be a common pattern in a number of PWM drivers it might
> make sense to simply add support for enabling/disabling a clk to the pwm core.
> Or maybe just use the runtime pm API for this. This probably makes even more
> sense and grab a reference to the pm context when the enable() is called,
> release it when disable() is called and also grab it before calling the
> device's config callback and release it afterward.

It's a problem with IPs in general, a good proportion of modern SoCs
need a clock supplying in order to interact with the registers on most
of their IPs.  runtime PM is the normal way forwards, Tegra recently
started using regmap's cache code to handle this transparently in the
driver.
