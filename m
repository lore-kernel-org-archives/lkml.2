Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab0JEQt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:49:29 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:27199
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752449Ab0JEQt2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:49:28 -0400
X-SpamScore: -37
X-BigFish: VS-37(zz542N1432N98dN179dN1521M9371Pzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ARM: imx: Add iram allocator functions
Date: Tue, 5 Oct 2010 09:49:19 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851050F1387@az33exm21>
In-Reply-To: <20101005075551.GJ11737@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ARM: imx: Add iram allocator functions
Thread-Index: ActkYsEH3lsXtGZwRRWI6svBIGHLvQAQUj0g
References: <1286237007-8463-1-git-send-email-Dinh.Nguyen@freescale.com> <20101005074423.GI11737@pengutronix.de> <20101005075551.GJ11737@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <amit.kucheria@canonical.com>,
        <s.hauer@pengutronix.de>, <grant.likely@secretlab.ca>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        Zhang Lily-R58066 <R58066@freescale.com>, <r.schwebel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Uwe Kleine-König [mailto:u.kleine-koenig@pengutronix.de]
> Sent: Tuesday, October 05, 2010 2:56 AM
> To: Nguyen Dinh-R00091
> Cc: linux-kernel@vger.kernel.org; amit.kucheria@canonical.com;
> s.hauer@pengutronix.de; grant.likely@secretlab.ca;
> valentin.longchamp@epfl.ch; daniel@caiaq.de; Zhang Lily-R58066;
> r.schwebel@pengutronix.de; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de
> Subject: Re: [PATCH] ARM: imx: Add iram allocator functions
> 
> On Tue, Oct 05, 2010 at 09:44:23AM +0200, Uwe Kleine-König wrote:
> > On Mon, Oct 04, 2010 at 07:03:27PM -0500, Dinh.Nguyen@freescale.com
> wrote:
> > > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > >
> > > Add iram allocation functions using GENERIC_ALLOCATOR. The
> > > allocation size is 4KB multiples to guarantee alignment. The
> > > idea for these functions is for i.MX platforms to use them
> > > to dynamically allocate IRAM usage.
> > >
> > > Applies on 2.6.36-rc6
> > >
> > > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > > Reviewed-by: Amit Kucheria <amit.kucheria@canonical.com>
> > > ---
> > >  arch/arm/plat-mxc/Kconfig                   |   10 ++++
> > >  arch/arm/plat-mxc/Makefile                  |    1 +
> > >  arch/arm/plat-mxc/include/mach/iram_alloc.h |   35 +++++++++++++++
> > >  arch/arm/plat-mxc/iram.c                    |   62
> +++++++++++++++++++++++++++
> > >  4 files changed, 108 insertions(+), 0 deletions(-)
> > >  create mode 100644 arch/arm/plat-mxc/include/mach/iram_alloc.h
> > >  create mode 100644 arch/arm/plat-mxc/iram.c
> > >
> > > diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
> > > index 6785db4..5e4ff93 100644
> > > --- a/arch/arm/plat-mxc/Kconfig
> > > +++ b/arch/arm/plat-mxc/Kconfig
> > > @@ -57,6 +57,16 @@ source "arch/arm/mach-mx5/Kconfig"
> > >
> > >  endmenu
> > >
> > > +config IRAM_ALLOC
> > > +	bool "Enable IRAM allocator"
> > > +	default y
> > The iram allocator isn't useful taken alone, no?  So I suggest to make
> > it
> Hmm.  It seems I forgot to finish this sentence, sorry.
> 
> Unless IRAM_ALLOC is an optional feature for new features to come I'd
> not make it user selectible, but let the new features select IRAM_ALLOC.
> If it's optional I wonder if "default y" should really be done.
> 
> Maybe better call the symbol just IRAM?

IRAM should be in almost all SoCs, but it will be dependent on various drivers to make use of the IRAM. I think not making it user selectable and add IRAM_ALLOC to defconfigs where IRAM_ALLOC is needed makes sense. For example, the reason I am adding IRAM_ALLOC is to support MX51 suspend code. The MX51 suspend code needs to be run from IRAM. I think also IRAM_ALLOC is more descriptive symbol.

> 
> > > +	iram_pool = gen_pool_create(12, -1);
> > 	if (!iram_pool)
> > 		...
> After rereading the commit log I wondered where the 4 KB are enforced.
> Maybe do
> 
> 	s/12/PAGE_SHIFT/
> 
> to make it more obvious?

I'm unclear about your comment. Should I add a comment of something like this?
/* 12^2 will create a 4KB granularity. */

> 
> Best regards
> Uwe
> 
> --
> Pengutronix e.K.                           | Uwe Kleine-König
> |
> Industrial Linux Solutions                 | http://www.pengutronix.de/
> |


