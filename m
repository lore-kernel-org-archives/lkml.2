Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1JSOrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:47:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57399 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab1JSOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:47:41 -0400
Date: Wed, 19 Oct 2011 15:47:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: patches@linaro.org, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        Rajendra Nayak <rnayak@ti.com>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111019144734.GI18713@sirena.org.uk>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111016145536.GA29885@S2100-06.ap.freescale.net>
 <4E9BAC4D.3010402@ti.com>
 <20111018115836.GC30703@S2100-06.ap.freescale.net>
 <20111018160046.GD28501@opensource.wolfsonmicro.com>
 <20111019053354.GB31162@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019053354.GB31162@S2100-06.ap.freescale.net>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 01:33:55PM +0800, Shawn Guo wrote:
> On Tue, Oct 18, 2011 at 05:00:46PM +0100, Mark Brown wrote:

> > It's not just Linux-specific stuff, some of this is even specific to
> > what current Linux drivers can do - updating the kernel could mean a
> > different set of constraints.

> Well, from what I see, the 'struct regulation_constraints' is defined
> in machine.h and meant to be the regulator machine/board interface.

...which will depend on the system integrator's understanding of what
their system is capable of right now.

> With the example I'm looking at, mc13892, the regulation_constraints
> configuration is fully passed from machine/board file.  If there is
> something specific to what drivers can do, it probably should be encoded
> in regulator driver rather than staying in regulation_constraints.

I don't think you're quite understanding the issue - it's an integration
problem with three different variables.  It's a combination of what the
chips can do, what the drivers can do and if the board design affects
any of this stuff.  Only the board can come to a final decision.
