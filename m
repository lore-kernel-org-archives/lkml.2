Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2ITTFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:05:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56271 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2ITTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:05:49 -0400
Date: Thu, 20 Sep 2012 20:05:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Beno??t Th??baudeau <benoit.thebaudeau@advansee.com>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm: Call pwm_enable() before pwm_config()
Message-ID: <20120920190544.GB13264@sirena.org.uk>
References: <36966374.2768747.1345741025741.JavaMail.root@advansee.com>
 <50366464.4070801@metafoo.de>
 <50366628.5020007@metafoo.de>
 <20120823190402.GA8127@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823190402.GA8127@avionic-0098.mockup.avionic-design.de>
X-Cookie: Use extra care when cleaning on stairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 09:04:02PM +0200, Thierry Reding wrote:

> Using runtime PM for this sounds indeed like the most generic approach.
> I'm not very familiar with the API, but I thought it required explicit
> architecture or bus support (or the driver itself can provide hooks via
> pm_ops), so it might be difficult to implement for platforms that don't
> have working runtime PM support. I'll have to look into this some more.

It doesn't require explicit arch support, though many architectures
choose to integrate their PM frameworks with it either directly or via
power domains.  If the architecture doesn't do anything with it then it
should just work at the driver level.
