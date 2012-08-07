Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2HGQgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:36:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39736 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752208Ab2HGQgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:36:15 -0400
Date: Tue, 7 Aug 2012 17:36:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807163612.GR16861@opensource.wolfsonmicro.com>
References: <20120806213124.GB14594@flint.arm.linux.org.uk>
 <20120807121157.GA10166@flint.arm.linux.org.uk>
 <20120807132510.GE16861@opensource.wolfsonmicro.com>
 <201208071428.15739.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208071428.15739.arnd@arndb.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:28:15PM +0000, Arnd Bergmann wrote:
> On Tuesday 07 August 2012, Mark Brown wrote:

> > As I said elsewhere 88pm* needs this as a stable bugfix and wm831x
> > should be converted over too.

> I've looked through the remaining MFD drivers and found one more,
> max8925-core, which is using IORESOURCE_IO for something that is
> not ISA/PCI IO-space.

Ah, yes - that's also used on Marvell platforms which presumably aren't
getting much mainline testing either.

> > > 2. Choosing a better name.

> > I'm not sure we need one, _REG seems perfectly fine here unless we want
> > to go with Arnd's suggestion of _OTHER.  Do you have any concerns with
> > the use of reg?

> BenH actually suggested _OTHER. I think either one is fine.

Sorry Ben.

> Now I've looked at the three drivers with the immediate problem of
> IORESOURCE_IO abuse (max8925, wm831x, 88pm860x) and none of them are
> doing such bitmask operations, so I'm reasonably sure we are fine

Hopefully nobody will add this to the core code either.  I wonder if
it's possible to change the definition of the constants for the resource
types so that they generate a warning if anyone does bitops on them...
that'd also get all the drivers fixed up eventually.

> for those drivers. I also agree that renumbering the resources in a
> way that makes it impossible to use bitmasks is a good idea, but
> that would actually be pretty invasive because then we have to rewrite
> all the functions that currently do it.

Yeah, that's why the new resource type has never been added - I don't
think anyone had considered the possibility of adding a new type without
also doing the renumbering, I know I didn't when I looked.
