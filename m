Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab2EDQFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:05:49 -0400
Received: from stoneboat.aleph1.co.uk ([80.68.88.63]:59709 "EHLO
	stoneboat.aleph1.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2EDQFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:05:47 -0400
Date: Fri, 4 May 2012 17:05:45 +0100
From: Wookey <wookey@wookware.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Deepak Saxena <dsaxena@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Martin Michlmayr <tbm@cyrius.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120504160545.GT27023@stoneboat.aleph1.co.uk>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Deepak Saxena <dsaxena@linaro.org>, linaro-dev@lists.linaro.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Martin Michlmayr <tbm@cyrius.com>
References: <201205031350.35476.arnd@arndb.de>
 <20120504142057.GQ27023@stoneboat.aleph1.co.uk>
 <20120504143518.GF26481@n2100.arm.linux.org.uk>
 <201205041517.58830.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205041517.58830.arnd@arndb.de>
Organization: Wookware          
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: wookey@wookware.org
X-SA-Exim-Scanned: No (on stoneboat.aleph1.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+++ Arnd Bergmann [2012-05-04 15:17 +0000]:
> On Friday 04 May 2012, Russell King - ARM Linux wrote:
> > 
> > On Fri, May 04, 2012 at 03:20:57PM +0100, Wookey wrote:
> > > Debian tries very hard not to support anything in the kernel that
> > > upstream don't support in the kernel because otherwise it's way too
> > > much work. The current list of supplied arm kernels is:
> > > 
> > > iop32x (ThecusN2100, intel SS4000, GLAN tank)
> > > ixp4xx (Linksys NSLU2)
> > > kirkwood (*plugs, QNAP NAS, OPenRD)
> > > orion5x (QNAP NAS, HP mv2120)
> > > versatile
> > > mx5
> > > omap
> > > 
> > > because that's a good compromise between coverage and 'building 20-odd
> > > images'. I have no idea how much of that lot is going to get DTified,
> > > but I'm guessing the older stuff won't be?
> 
> Thanks for the list, Wookey!
> 
> This is very important because distros are obviously the primary consumer
> of multiplatform builds (aside from build testing). The goal should very
> much be to reduce the number of distinct kernels that folks like debian,
> fedora or cyanogenmod have to build.

Just to be clear, we'd very much like to support more hardware, ideally
'everything a significant number of people have', but the overhead to
the whole distro for each new kernel added to the build (for every
upload, slowing and potentially breaking releases on all arches) is
sufficiently high that we have been strict about what is supported. As
a result a lot of people use Debian with non-distro kernels.

Obviously missing things are tegra, dove/armada, omap4. Freerunner
would have been nice a while back but probably a bit late now. 

It's not clear to me how many omap platforms our 'omap' kernel
actually serves in practice, and similarly for the other 'generic'
kernels.

Obviously any and all progress in the direction of making existing
coverage or expanded coverage easier/faster/more-reliable/simpler is
very welcome. 

> > So, that means your list should reduce down to five kernels, or three if
> > the Orion/Kirkwood stuff gets converted to DT.
> 
> I count four if we were to proceed with the initial proposal:
> 
> 1. ARMv6/v7 multiplatform: omap2plus, mx5/mx6, vexpress, ...
> 2. ARMv4/v5 multiplatform: versatile, orion5x, kirkwood, , ...
> 3. iop32x
> 4. ixp4xx
> 
> 	Arnd
