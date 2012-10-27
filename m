Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2J0OIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:08:13 -0400
Received: from [213.199.154.206] ([213.199.154.206]:3308 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932119Ab2J0OIL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:08:11 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 8
X-BigFish: VPS8(zz98dI9371I542M1432I4015Izz1202h1d1ah1d2ahzz8275bhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>
CC: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: RE: [PATCH v4 1/5] zynq: use GIC device tree bindings
Thread-Topic: [PATCH v4 1/5] zynq: use GIC device tree bindings
Thread-Index: AQHNsiKfdYDo+gun80qPdhWl+8WGNZfNMsx5gAAATlA=
Date: Sat, 27 Oct 2012 14:06:45 +0000
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
 <0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
 <20121027140053.GB5190@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121027140053.GB5190@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <4fd22fac-49c4-4000-9e70-12e94f248753@AM1EHSMHS010.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh

> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Saturday, October 27, 2012 4:01 PM
> To: Michal Simek
> Cc: arm@kernel.org; Arnd Bergmann; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; John Linn; Nick Bowler
> Subject: Re: [PATCH v4 1/5] zynq: use GIC device tree bindings
> 
> On Sat, Oct 27, 2012 at 01:39:00PM +0000, Michal Simek wrote:
> > Hi Josh,
> >
> > > -----Original Message-----
> > > From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> > > Sent: Wednesday, October 24, 2012 10:03 PM
> > > To: arm@kernel.org; Arnd Bergmann
> > > Cc: linux-kernel@vger.kernel.org;
> > > linux-arm-kernel@lists.infradead.org; John Linn; Nick Bowler; Michal
> > > Simek
> > > Subject: [PATCH v4 1/5] zynq: use GIC device tree bindings
> > >
> > > The Zynq uses the cortex-a9-gic.  This eliminates the need to
> > > hardcode register addresses.
> > >
> > > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> > > Cc: John Linn <john.linn@xilinx.com>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  arch/arm/boot/dts/zynq-ep107.dts           | 8 +++++---
> > >  arch/arm/mach-zynq/common.c                | 7 ++++++-
> > >  arch/arm/mach-zynq/include/mach/zynq_soc.h | 2 --
> > >  3 files changed, 11 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/arch/arm/boot/dts/zynq-ep107.dts
> > > b/arch/arm/boot/dts/zynq- ep107.dts index 37ca192..7bfff4a 100644
> > > --- a/arch/arm/boot/dts/zynq-ep107.dts
> > > +++ b/arch/arm/boot/dts/zynq-ep107.dts
> > > @@ -36,10 +36,12 @@
> > >               ranges;
> > >
> > >               intc: interrupt-controller@f8f01000 {
> > > +                     compatible = "arm,cortex-a9-gic";
> > > +                     #interrupt-cells = <3>;
> >
> > If you change git to 3 cells format you should also change it for uart below.
> >
> > Also will be the best to remove this dts entirely and replace it by
> > existing Platform.
> 
> Do you mean to say get rid of the ep107 entirely and replace it with, for
> example, a zc702 dts?

Yes, Ep107 platform is nothing what you can buy, that's why it is not the platform
Which should be supported in mainline. Supporting zc702 make sense.

> 
> I have a follow up patchset which splits off a zynq-7000.dtsi and a zynq-
> zc702.dts, and which also fixes the 3 interrupt cell problem.

I am not big fan to use dtsi solution because dts can be simple generated directly
>From Xilinx design tool based on your hw design. That's why I can't see any benefit
To have dtsi file. 

> Would you like for me to pull this into v5, or spin up a separate patch series?

Definitely not. I have checked patches but haven't got it work on the zc702.
Not sure if you have run it on real hw or just on the qemu as you have mentioned
In 5/5.

Thanks,
Michal


