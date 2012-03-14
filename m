Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab2CNISj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:18:39 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:13079
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab2CNISe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:18:34 -0400
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 16:20:24 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Rob Herring <robherring2@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1 3/5] ARM: imx28evk: add mmc dt support
Message-ID: <20120314082024.GB1180@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-4-git-send-email-b29396@freescale.com>
 <4F5F5C22.1080506@gmail.com>
 <20120313165214.GO26642@pengutronix.de>
 <4F5F879E.4030407@gmail.com>
 <20120314073035.GI18320@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120314073035.GI18320@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:30:35PM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 12:45 Tue 13 Mar     , Rob Herring wrote:
> > On 03/13/2012 11:52 AM, Sascha Hauer wrote:
> > > On Tue, Mar 13, 2012 at 09:39:30AM -0500, Rob Herring wrote:
> > >> On 03/13/2012 03:47 AM, Dong Aisheng wrote:
> > >>> From: Dong Aisheng <dong.aisheng@linaro.org>
> > >>>
> > >>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > >>> ---
> > >>>  arch/arm/boot/dts/imx28-evk.dts |   14 ++++++++++++++
> > >>>  arch/arm/boot/dts/imx28.dtsi    |   33 +++++++++++++++++++++++++++++++++
> > >>>  arch/arm/mach-mxs/imx28-dt.c    |    2 ++
> > >>>  3 files changed, 49 insertions(+), 0 deletions(-)
> > >>
> > >> snip
> > >>
> > >>> diff --git a/arch/arm/mach-mxs/imx28-dt.c b/arch/arm/mach-mxs/imx28-dt.c
> > >>> index 78d1129..429b88e 100644
> > >>> --- a/arch/arm/mach-mxs/imx28-dt.c
> > >>> +++ b/arch/arm/mach-mxs/imx28-dt.c
> > >>> @@ -23,6 +23,8 @@ static const struct of_dev_auxdata imx28_auxdata_lookup[] __initconst = {
> > >>>  	OF_DEV_AUXDATA("arm,pl011", MX28_DUART_BASE_ADDR, "duart", NULL),
> > >>>  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC0_BASE_ADDR, "imx28-fec.0", NULL),
> > >>>  	OF_DEV_AUXDATA("fsl,imx28-fec", MX28_ENET_MAC1_BASE_ADDR, "imx28-fec.1", NULL),
> > >>> +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP0_BASE_ADDR, "mxs-mmc.0", NULL),
> > >>> +	OF_DEV_AUXDATA("fsl,imx28-mmc", MX28_SSP1_BASE_ADDR, "mxs-mmc.1", NULL),
> > >>
> > >> Why is this needed?
> > > 
> > > These are needed for the drivers which have still the mxs-mmc.* names
> > > to find their clocks. Alternatively we could also add the appropriate
> > > clocks to the clock file. Don't know if that's better though.
> > 
> > Ah, yes I should have known that... If clk lookup is all that's needed,
> > I'd suggest adding the necessary clk lookups either here or in the clock
> > code. Not much difference, but at least it removes the use of
> > *_BASE_ADDR defines.
> Agreed we do this on AT91
> 
I'm willing to do like that.
But i'm new to this, can you help point our where the code i can reference
in Rob suggested way?

Regards
Dong Aisheng

