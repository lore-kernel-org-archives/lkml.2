Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2DXNyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:54:23 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:59379
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483Ab2DXNyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:54:21 -0400
X-SpamScore: -11
X-BigFish: VS-11(zcb8kz154dM1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 24 Apr 2012 22:04:25 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2 3/3] ARM: imx6q: switch to use pinctrl driver
Message-ID: <20120424140425.GB24122@shlinux2.ap.freescale.net>
References: <1334933916-12971-1-git-send-email-b29396@freescale.com>
 <1334933916-12971-3-git-send-email-b29396@freescale.com>
 <20120424124634.GH9142@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120424124634.GH9142@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 08:46:34PM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 22:58 Fri 20 Apr     , Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > ---
> > This is not a formal patch and is only used for test
> > since before the pinctrl core handle dummy state is in,
> > enable pinctrl in driver will break other platforms.
> > 
> > ChangeLog v1->v2:
> > * using updated binding
> > ---
> >  arch/arm/boot/dts/imx6q-arm2.dts   |    2 ++
> >  arch/arm/boot/dts/imx6q.dtsi       |   17 +++++++++++++++++
> >  arch/arm/mach-imx/Kconfig          |    2 ++
> >  drivers/mmc/host/sdhci-esdhc-imx.c |   12 ++++++++++++
> >  4 files changed, 33 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/imx6q-arm2.dts b/arch/arm/boot/dts/imx6q-arm2.dts
> > index ce1c823..68b1d8d 100644
> > --- a/arch/arm/boot/dts/imx6q-arm2.dts
> > +++ b/arch/arm/boot/dts/imx6q-arm2.dts
> > @@ -44,6 +44,8 @@
> >  				fsl,card-wired;
> >  				vmmc-supply = <&reg_3p3v>;
> >  				status = "okay";
> > +				pinctrl-names = "default";
> > +				pinctrl-0 = <&pinctrl_usdhc4_1>;
> >  			};
> >  
> >  			uart4: uart@021f0000 {
> > diff --git a/arch/arm/boot/dts/imx6q.dtsi b/arch/arm/boot/dts/imx6q.dtsi
> > index 4905f51..8cbd88b 100644
> > --- a/arch/arm/boot/dts/imx6q.dtsi
> > +++ b/arch/arm/boot/dts/imx6q.dtsi
> > @@ -386,7 +386,24 @@
> >  			};
> >  
> >  			iomuxc@020e0000 {
> > +				compatible = "fsl,imx6q-iomuxc";
> >  				reg = <0x020e0000 0x4000>;
> > +
> > +				/* shared pinctrl settings */
> > +				usdhc4 {
> > +					pinctrl_usdhc4_1: usdhc4grp-1 {
> > +						fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
> > +							    1392 0x17059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
> > +							    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
> > +							    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
> > +							    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
> > +							    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
> > +							    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
> > +							    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
> > +							    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
> > +							    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
> Can you on IMX have alternative onfiguration where you use as example just one
> pin on a different pad?
> 
Well, it's a good question.
If user wants to set a different pad configuration for one pin in a exist group,
he may need to create a new group node to hold that pin settings.
This is the limitation since we can not enumerate all available pin
configurations.

I think what we can do may be:
For those easy changed pins, user could define the pin configuration node in
board dts file where devices can use one more phandle to reference it to do
minor fixup. Then we do not need to frequently change the SoC dtsi file.

For not easy changed pins, we can just add the new group in soc dtsi file
for people to use.

Regards
Dong Aisheng

