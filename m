Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2DZPgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:36:01 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:54149 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752161Ab2DZPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:36:00 -0400
X-Greylist: delayed 1244 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2012 11:36:00 EDT
Date: Thu, 26 Apr 2012 17:15:36 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: b20223@freescale.com, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de, cjb@laptop.org,
        s.hauer@pengutronix.de, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core
 driver
Message-ID: <20120426151536.GO9142@game.jcrosoft.org>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426144446.GN9142@game.jcrosoft.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7733243511994952551
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtdekucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +Examples:
> > +usdhc@0219c000 { /* uSDHC4 */
> > +	fsl,card-wired;
> > +	vmmc-supply = <&reg_3p3v>;
> > +	status = "okay";
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&pinctrl_usdhc4_1>;
> > +};
> > +
> > +iomuxc@020e0000 {
> > +	compatible = "fsl,imx6q-iomuxc";
> > +	reg = <0x020e0000 0x4000>;
> > +
> > +	/* shared pinctrl settings */
> > +	usdhc4 {
> > +		pinctrl_usdhc4_1: usdhc4grp-1 {
> > +			fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
> > +				    1392 0x17059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
> > +				    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
> > +				    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
> > +				    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
> > +				    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
> > +				    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
> > +				    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
> > +				    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
> > +				    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
> honestly I don't like this it's obscure need to decode manually
> 
> I propose to use phandle
> 
> as example on uart you will want or not the rst/cts so you will have quite a
> lot of bindings
> 
> so you can describe the pin configuration (function) and refer it by phandle
> in the group
We have on Imx mxc at91 and other SoC controler hich you configure per pin

which means one pin have multiple function and the same function is on
multiple pins

so the groups are just a list of possible pins

Instead of re-inventing bindings we do need to come with a common binding whre
it's possible

So instead I proppose (send in the v2) to use common way to describe the group

1) we describe one function per pin

	functions {
		rxd_pb12 {
			atmel,pin-id = <44>;
			atmel,mux = <0>;
		};

		txd_pb13 {
			atmel,pin-id = <45>;
			atmel,pull = <2>;
			atmel,mux = <0>;
		};

		txd0_pb19 {
			atmel,pin-id = <51>;
			atmel,pull = <2>;
			atmel,mux = <0>;
		};

		rxd0_pb18 {
			atmel,pin-id = <50>;
			atmel,mux = <0>;
		};

		rts0_pb17 {
			atmel,pin-id = <49>;
			atmel,mux = <1>;
		};

		cts0_pb15 {
			atmel,pin-id = <47>;
			atmel,mux = <1>;
		};
	};


advantage if you need to set a pull-up or any pin parameter different on your board
you can overwrite it without re-creating a group

This is controller specific

and then we have the common bindings to describe the group
by using phandle of the functions to describe the group

	groups {
		dbgu {
			pinctrl,functions = < &rxd_pb12
					      &txd_pb13 >;
		};

		uart0_rxd_txd {
			pinctrl,functions = < &rxd0_pb18
					      &txd0_pb19 >;
		};

		uart0_rts_cts {
			pinctrl,functions = < &rxd0_pb18
					      &txd0_pb19
					      &rts0_pb17
					      &cts0_pb15 >;
		};
	};

this will be handle by a generic code in c

Best Regards,
J.
