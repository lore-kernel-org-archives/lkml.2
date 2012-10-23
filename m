Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224Ab2JXCY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:24:57 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:42550 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab2JXCYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:24:54 -0400
Date: Tue, 23 Oct 2012 17:17:42 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Josh Cartwright <josh.cartwright@ni.com>
Cc: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v2 2/4] zynq: move static peripheral mappings
Message-ID: <20121023211742.GA14047@elliptictech.com>
References: <20121022211219.GC31538@beefymiracle.amer.corp.natinst.com>
 <201210231450.11540.arnd@arndb.de>
 <5086F973.6050309@gmail.com>
 <20121023205304.GJ20593@beefymiracle.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023205304.GJ20593@beefymiracle.amer.corp.natinst.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-23 15:53 -0500, Josh Cartwright wrote:
> On Tue, Oct 23, 2012 at 03:09:23PM -0500, Rob Herring wrote:
> > On 10/23/2012 09:50 AM, Arnd Bergmann wrote:
> > > On Monday 22 October 2012, Josh Cartwright wrote:
> > >> -#define SCU_PERIPH_PHYS			0xF8F00000
> > >> -#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
> > >> +#define SCU_PERIPH_PHYS		0xF8F00000
> > >> +#define SCU_PERIPH_SIZE		SZ_8K
> > >> +#define SCU_PERIPH_VIRT		(PL310_L2CC_VIRT - SCU_PERIPH_SIZE)
> > >
> > > And your patch 3 already obsoletes this mapping.
> >
> > Actually, it's probably still needed. The smp platform code typically
> > reads the number of cores from the SCU and the mapping has to be in
> > place before ioremap is up. I don't think there is an architected way to
> > get the number of cores, but it would be nice to avoid this early SCU
> > access. We could also mandate getting the core count from DT instead.
> >
> > Also, the physical address can be read with this on A9's:
> >
> >         asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));
> 
> For the sake of the zynq cleanups, I think it may still make sense to
> remove the SCU peripheral mappings for now.  By the time we're ready to
> push in SMP support for zynq, maybe we can tackle the problem of how to
> solve the SCU mapping problem generically.

Then the static mapping can be removed if and when the we "solve the SCU
mapping problem generically".  There's no point in removing it until
then since it doesn't cause any actual problems, does it?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
