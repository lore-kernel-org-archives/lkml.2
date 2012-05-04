Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab2EDPSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:18:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50710 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2EDPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:18:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Fri, 4 May 2012 15:17:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Wookey <wookey@wookware.org>, Deepak Saxena <dsaxena@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linaro-dev@lists.linaro.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <201205031350.35476.arnd@arndb.de> <20120504142057.GQ27023@stoneboat.aleph1.co.uk> <20120504143518.GF26481@n2100.arm.linux.org.uk>
In-Reply-To: <20120504143518.GF26481@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041517.58830.arnd@arndb.de>
X-Provags-ID: V02:K0:zAXpRU1G/vjTCN/H9SLf5LwxMyCYSIAjfr8h9+aCp4m
 abkeXdRh3ai6BeHy6EFlORf4brKx9XSAXGqCNW01JJ0MSSNiVv
 xk3EQoIPy/pd1UcZMq7n873SbdbOo6ti2BZ0Olhf6T4tomsKgi
 gvi2ZvRT0os3Cr7oqPdOPpL98QhX5S744Kh+v9q+pIgknB0jSQ
 ElgB6ontRANs24i8V2bUpPlkKPXkcBQqnC5x2fr8gVf4m3aD5w
 wRVFo2w8No7UlMhpyQqWQB9A+/PX+LFZBshg9tc3M9xJwy2uGP
 gHP8utCUOobzKhYAhjmBgzm1PjUu0CH5DH2t36L7QTGwJjy0UU
 78zjcbSHjz9Mc5aEP/+o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Russell King - ARM Linux wrote:
> 
> On Fri, May 04, 2012 at 03:20:57PM +0100, Wookey wrote:
> > Debian tries very hard not to support anything in the kernel that
> > upstream don't support in the kernel because otherwise it's way too
> > much work. The current list of supplied arm kernels is:
> > 
> > iop32x (ThecusN2100, intel SS4000, GLAN tank)
> > ixp4xx (Linksys NSLU2)
> > kirkwood (*plugs, QNAP NAS, OPenRD)
> > orion5x (QNAP NAS, HP mv2120)
> > versatile
> > mx5
> > omap
> > 
> > because that's a good compromise between coverage and 'building 20-odd
> > images'. I have no idea how much of that lot is going to get DTified,
> > but I'm guessing the older stuff won't be?

Thanks for the list, Wookey!

This is very important because distros are obviously the primary consumer
of multiplatform builds (aside from build testing). The goal should very
much be to reduce the number of distinct kernels that folks like debian,
fedora or cyanogenmod have to build.

> Well, my understanding is that there's DT patches around for Versatile.
> OMAP and MX5 are both heading for DT.  I'm less certain about the Orion
> and Kirkwood stuff, but as they're only about 4 years old, I would hope
> that there was some active movement for these.

FWIW, there is a lot of new activity on orion5x and kirkwood (less on
mv78xxx and dove) and new board support for those platforms is being done
using DT already, at least for the drivers that have been converted.

As soon as the support is complete, I would hope that we can add dts files
for the older boards that people are using as well, and a few releases
later remove the respective board files.
 
> The iop32x and ixp4xx stuff hasn't seen much in the way of maintenance
> so its highly likely that these won't be converted to DT unless someone
> with the hardware decides to step up and do it.

Right. For those, I agree that it makes sense to support them without DT
even in a multiplatform kernel. So I'll revise my initial proposal to

* For mach-* directories that we expect to support using DT in the
  near future, support the ATAG based board files only in the current
  (single-platform, multi-board) way but not for multiplatform (i.e.
  multiple mach-*/ combined) builds.
* For mach-* directories that look like they will not support DT anytime
  soon, support them as is in the multiplatform build, possibly enabling
  all their boards (or a well-defined subset) unconditionally.

> So, that means your list should reduce down to five kernels, or three if
> the Orion/Kirkwood stuff gets converted to DT.

I count four if we were to proceed with the initial proposal:

1. ARMv6/v7 multiplatform: omap2plus, mx5/mx6, vexpress, ...
2. ARMv4/v5 multiplatform: versatile, orion5x, kirkwood, , ...
3. iop32x
4. ixp4xx

	Arnd
