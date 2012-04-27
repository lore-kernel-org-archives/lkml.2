Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2D0Gvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:51:50 -0400
Received: from 19.mo4.mail-out.ovh.net ([87.98.179.66]:43278 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753432Ab2D0Gvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:51:49 -0400
X-Greylist: delayed 45692 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 02:51:48 EDT
Date: Fri, 27 Apr 2012 08:31:09 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120427063109.GR9142@game.jcrosoft.org>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
 <20120427034825.GA826@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427034825.GA826@shlinux2.ap.freescale.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4750734657019948013
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +   this group of pins in this pin configuration node are working on.
> > > +3. The driver can use the function node's name and pin configuration node's
> > > +   name describe the pin function and group hierarchy.
> > > +   For example, Linux IMX pinctrl driver takes the function node's name
> > > +   as the function name and pin configuration node's name as group name to
> > > +   create the map table.
> > > +4. Each pin configuration node should have a phandle, devices can set pins
> > > +   configurations by referring to the phandle of that pin configuration node.
> > > +
> > > +Examples:
> > > +usdhc@0219c000 { /* uSDHC4 */
> > > +	fsl,card-wired;
> > > +	vmmc-supply = <&reg_3p3v>;
> > > +	status = "okay";
> > > +	pinctrl-names = "default";
> > > +	pinctrl-0 = <&pinctrl_usdhc4_1>;
> > > +};
> > > +
> > > +iomuxc@020e0000 {
> > > +	compatible = "fsl,imx6q-iomuxc";
> > > +	reg = <0x020e0000 0x4000>;
> > > +
> > > +	/* shared pinctrl settings */
> > > +	usdhc4 {
> > > +		pinctrl_usdhc4_1: usdhc4grp-1 {
> > > +			fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
> > > +				    1392 0x17059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
> > > +				    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
> > > +				    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
> > > +				    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
> > > +				    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
> > > +				    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
> > > +				    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
> > > +				    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
> > > +				    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
> > honestly I don't like this it's obscure need to decode manually
> > 
> > I propose to use phandle
> > 
> > as example on uart you will want or not the rst/cts so you will have quite a
> > lot of bindings
> > 
> > so you can describe the pin configuration (function) and refer it by phandle
> > in the group
> > 
> Hmm, i can't say you're wrong.
> What you suggested may be suitable for your SoCs, before i know more about your SoC
> details, i may not comment too much.
> 
> The binding i used here basically follows the exist iomux v3 convention which we're
> using for non dt platforms, i think most people working on fsl platform may would
> want a similar using as before since iomux v3 is very easy to use for imx soc.
> You can refer to: iomux-mx51.h.
> 
> After dt macro support is available(which is still in progress), we may
> convert the raw data above to raw data then user do not need to decode
> the setting anymore.
this is not an excuse to duplicate bindings

Best Regards,
J.
