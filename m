Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2CODAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 23:00:32 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:40063 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab2CODAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 23:00:31 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Mar 2012 11:02:07 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
Message-ID: <20120315030206.GB13022@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-2-git-send-email-b29396@freescale.com>
 <20120313172351.97C5E3E053B@localhost>
 <20120314124512.GG1180@shlinux2.ap.freescale.net>
 <20120314141643.GP3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120314141643.GP3852@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:16:43PM +0800, s.hauer@pengutronix.de wrote:
> On Wed, Mar 14, 2012 at 08:45:23PM +0800, Dong Aisheng wrote:
> > On Wed, Mar 14, 2012 at 01:23:51AM +0800, Grant Likely wrote:
> > > On Tue, 13 Mar 2012 16:47:04 +0800, Dong Aisheng <b29396@freescale.com> wrote:
> > > > From: Dong Aisheng <dong.aisheng@linaro.org>
> > > > 
> > > > This patch includes basic dt support which can boot via nfs rootfs.
> > > > 
> > > > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > > > ---
> > > >  Documentation/devicetree/bindings/arm/fsl.txt |    4 +
> > > >  arch/arm/boot/dts/imx28-evk.dts               |   31 +++++++++
> > > >  arch/arm/boot/dts/imx28.dtsi                  |   88 +++++++++++++++++++++++++
> > > >  arch/arm/mach-mxs/Kconfig                     |    9 +++
> > > >  arch/arm/mach-mxs/Makefile                    |    1 +
> > > >  arch/arm/mach-mxs/imx28-dt.c                  |   67 +++++++++++++++++++
> > > >  6 files changed, 200 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/arm/fsl.txt b/Documentation/devicetree/bindings/arm/fsl.txt
> > > > index 54bddda..9f21faf 100644
> > > > --- a/Documentation/devicetree/bindings/arm/fsl.txt
> > > > +++ b/Documentation/devicetree/bindings/arm/fsl.txt
> > > > @@ -1,6 +1,10 @@
> > > >  Freescale i.MX Platforms Device Tree Bindings
> > > >  -----------------------------------------------
> > > >  
> > > > +i.MX28 Evaluation Kit
> > > > +Required root node properties:
> > > > +    - compatible = "fsl,imx28-evk", "fsl,imx28";
> > > > +
> > > >  i.MX51 Babbage Board
> > > >  Required root node properties:
> > > >      - compatible = "fsl,imx51-babbage", "fsl,imx51";
> > > > diff --git a/arch/arm/boot/dts/imx28-evk.dts b/arch/arm/boot/dts/imx28-evk.dts
> > > > new file mode 100644
> > > > index 0000000..9758dc4
> > > > --- /dev/null
> > > > +++ b/arch/arm/boot/dts/imx28-evk.dts
> > > > @@ -0,0 +1,31 @@
> > > > +/*
> > > > + * Copyright 2012 Freescale Semiconductor, Inc.
> > > > + *
> > > > + * The code contained herein is licensed under the GNU General Public
> > > > + * License. You may obtain a copy of the GNU General Public License
> > > > + * Version 2 or later at the following locations:
> > > > + *
> > > > + * http://www.opensource.org/licenses/gpl-license.html
> > > > + * http://www.gnu.org/copyleft/gpl.html
> > > > + */
> > > > +
> > > > +/dts-v1/;
> > > > +/include/ "imx28.dtsi"
> > > > +
> > > > +/ {
> > > > +	model = "Freescale i.MX28 Evaluation Kit";
> > > > +	compatible = "fsl,imx28-evk", "fsl,imx28";
> > > > +
> > > > +	memory {
> > > > +		device_type = "memory";
> > > > +		reg = <0x40000000 0x08000000>;
> > > > +	};
> > > > +
> > > > +	ahb@80080000 {
> > > > +		fec@800f0000 {
> > > > +			phy-mode = "rmii";
> > > > +			local-mac-address = [00 04 9F 01 7D 5B];
> > > 
> > > Generally a bad idea to put a specific mac address into the device tree.
> > > Better to fill it with zeros.  Otherwise all the dev boards will end up using
> > > the same value.
> > > 
> > Yes, this issue also exists on other platfroms like mx6q.
> > One way is to dynamically get mac address by reading otp register as non-dt does
> > like:
> > static int __init mx28evk_fec_get_mac(void)
> > {
> >         int i;
> >         u32 val;
> >         const u32 *ocotp = mxs_get_ocotp();
> > 
> >         if (!ocotp)
> >                 return -ETIMEDOUT;
> > 
> >         /*
> >          * OCOTP only stores the last 4 octets for each mac address,
> >          * so hard-code Freescale OUI (00:04:9f) here.
> >          */
> >         for (i = 0; i < 2; i++) {
> >                 val = ocotp[i];
> >                 mx28_fec_pdata[i].mac[0] = 0x00;
> >                 mx28_fec_pdata[i].mac[1] = 0x04;
> >                 mx28_fec_pdata[i].mac[2] = 0x9f;
> >                 mx28_fec_pdata[i].mac[3] = (val >> 16) & 0xff;
> >                 mx28_fec_pdata[i].mac[4] = (val >> 8) & 0xff;
> >                 mx28_fec_pdata[i].mac[5] = (val >> 0) & 0xff;
> >         }
> > 
> >         return 0;
> > }
> > 
> > But it seems this needs pass mac address to fec driver via platforom data which is
> > not friendly to dt.
> > 
> > Another way may be changing fec driver to get the fixed part of mac address(first
> > two bytes) from device tree and read the left dynamical part from otp which i'm not
> > sure is better enough.
> > 
> > BTW, filling with zeros seems not work since it's invalid mac address.
> 
> Yes, that's the idea of using this value...
> 
But comparing to use an invalid value, why not just do not define that
local-mac-address property?

Regards
Dong Aisheng

