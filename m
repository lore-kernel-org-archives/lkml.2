Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2EXJho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:37:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51241 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198Ab2EXJhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:37:43 -0400
Date: Thu, 24 May 2012 10:37:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN itself
Message-ID: <20120524093739.GF5361@opensource.wolfsonmicro.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au>
 <4FBBAF1B.1070702@xenotime.net>
 <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
 <20120523093208.GB4085@opensource.wolfsonmicro.com>
 <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
 <20120523173342.GB4064@opensource.wolfsonmicro.com>
 <alpine.DEB.2.00.1205231735100.8785@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1205231810570.28167@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1205231810570.28167@chino.kir.corp.google.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 06:12:18PM -0700, David Rientjes wrote:

> you did it with a bogus commit message that insists this is only a 
> randconfig issue when in reality you never tested enabling 
> CONFIG_MFD_PALMAS without CONFIG_IRQ_DOMAIN when you merged 4af8be67fd99 
> ("regmap: Convert regmap_irq to use irq_domain").

JFTR all randconfig means is that it doesn't seem like a configuration a
human is likely to generate for use on an actual system as opposed to
build coverage - in this case the driver is for the PMIC for some new
ARM SoCs so it's unlikely that someone would want to run the driver on a
system that doesn't have DT (and hence IRQ domains) enabled.

With this sort of dependency error failures are generally either in
configurations you'd expect people to want to run (which obviously
affect users), in allXconfig builds (which get run a lot for all sorts
of reasons and so are urgent even if it's unlikely people will use them
in production) or in randconfig builds (which should work and are
potentially sensible configurations but can also turn up combinations
that aren't that realistic).  All of these should be fixed if they
break.
