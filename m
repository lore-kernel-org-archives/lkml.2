Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710Ab2HVLVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:21:15 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:29472
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab2HVLVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:21:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zcb8kz98dI1432Izz1202h1082kzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1155h)
Date: Wed, 22 Aug 2012 19:02:10 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Zhao Richard-B20223 <B20223@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "paul.liu@linaro.org" <paul.liu@linaro.org>
Subject: Re: [PATCH 6/7] ARM: dts: imx6q: add simple-bus compatible string
 for anatop
Message-ID: <20120822110209.GC10057@shlinux2.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-7-git-send-email-b29396@freescale.com>
 <20120822085236.GK4011@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120822085236.GK4011@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 04:52:36PM +0800, Zhao Richard-B20223 wrote:
> On Wed, Aug 22, 2012 at 03:18:47PM +0800, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Originally the anatop regulator devices are populated by mfd anatop driver.
> > Since mfd anatop driver will be deleted later, we change to populate the
> > regulator devices by devicetree automatically.
> > This will cause some warning messages as follows during boot due to device
> > recreation: "vdd1p1: Failed to create debugfs directory"
> > But it does not break any function.
> > Later, we will remove mfd anatop driver which can get rid of this
> > error message.
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> >  arch/arm/boot/dts/imx6q.dtsi |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> > index 7076be0..426f735 100644
> > --- a/arch/arm/boot/dts/imx6q.dtsi
> > +++ b/arch/arm/boot/dts/imx6q.dtsi
> > @@ -379,7 +379,7 @@
> >  			};
> >  
> >  			anatop: anatop@020c8000 {
> > -				compatible = "fsl,imx6q-anatop", "fsl,imx-syscon";
> > +				compatible = "fsl,imx6q-anatop", "fsl,imx-syscon", "simple-bus";
> To prevent bisect break, it should merge with patch #4.
Yes, i will try it and merge them if needed.

> It's really strange to use simple-bus, because it's not a bus.
I can't say it's strange or not.
There are existing using examples, imx28.dtsi.

> I like more the way how anatop driver handle it. Anatop driver populate
> devices in its code.
The anatop mfd driver will be deleted later.
So the proper solution may be generating regulator devices automatically when call
of_platform_populate in mach code rather than populate it in driver itself.

Regards
Dong Aisheng

