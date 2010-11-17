Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772Ab0KQNcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:32:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40502 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab0KQNcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:32:17 -0500
Date: Wed, 17 Nov 2010 13:32:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regulator: Move lp3971 regulator driver to
	subsys_initcall()
Message-ID: <20101117133213.GJ3338@sirena.org.uk>
References: <1289962844.8233.2.camel@mola> <20101117081205.GB11542@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117081205.GB11542@pengutronix.de>
X-Cookie: Who messed with my anti-paranoia shot?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 09:12:05AM +0100, Wolfram Sang wrote:
> On Wed, Nov 17, 2010 at 11:00:44AM +0800, Axel Lin wrote:

> > Regulators need to be available early in init in order to allow them
> > to be available for consumers when requested.

> > Other regulator drivers are already moved to subsys_initcall(),
> > looks like only lp3971 is missing.

> My 2 cents: it is safer to create such patches with real HW when there is a
> need (we deal with a similar situation in i2c). Janitorial might do more harm
> than good. Another option might be to call the patch a RFC?

Essentially any regulator driver has this requirement, it's just
something that was missed in the review when the patch was merged.
Grant has an idea for dealing with this differently by postpoing
registraton of dependant devices but for now all regulator drivers
should be registered early.
