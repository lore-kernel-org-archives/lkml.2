Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab2EDQAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:00:01 -0400
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:58700 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140Ab2EDP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:59:59 -0400
Date: Fri, 4 May 2012 17:32:51 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120504153251.GE7788@game.jcrosoft.org>
References: <20120502172401.GG3739@atomide.com>
 <20120503065131.GA3738@game.jcrosoft.org>
 <20120503152708.GC5140@atomide.com>
 <4FA30805.5050804@wwwdotorg.org>
 <20120504044305.GD7788@game.jcrosoft.org>
 <20120504150342.GI5140@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120504150342.GI5140@atomide.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 18138528975170480923
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeghedrtdehucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeghedrtdehucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:03 Fri 04 May     , Tony Lindgren wrote:
> * Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120503 22:08]:
> > 
> > In my mind in the driver we do not have to care how to list
> > register/unregister the group. We just need to be able to do this
> > 
> > pinctrl_register_group(...)
> > 
> > or 
> > 
> > pinctrl_unregistewr_group(...)
> > 
> > On at91 we have this type of controller
> 
> Ah I see. Yeah makes sense. Also I think we should let the pinctrl
> core eventually manage the pins more too. Right now the pins are
> a static array in the driver, which makes things unnecessarily
> complex for the DT case. It would be nice to also have something like
> pinctrl_register/unregister_pin instead of requiring them all
> be registered while registering with the framework initially.
> 
> But all that can be improved later on once we get the binding down..
agreed at 100%
>  
> > one pin can have multiple function and each function can be on different pin
> > and we need to program and represent each of them one by one
> > 
> > And each pin have different parameter
> > 
> > so I was thinking to do like on gpio
> > 
> > uart {
> > 	pin = < &pioA 12 {pararms} >
> > 
> > }
> 
> Hmm I assume the "12" above the gpio number?
no pin number in the bank because it could not be gpio

evenif on at91 and nearly on the controller I known it is the case
>  
> > and use macro as basicaly we are just this
> > 
> > and this can be applied to tegra too as you will just refer the pin in this hw
> > pin block
> 
> I was thinking of adding gpio eventually as a separate attribute with
> something like the following. Here cam_d10 pin is used as gpio109:
> 
> cam_d10.gpio_109 {
> 	pinctrl-simple,cells = <0xfa 0x104>;	/* OMAP_PIN_INPUT | OMAP_MUX_MODE4 */
> 	gpio = <&gpio4 13 0>;			/* gpio109 */
> };
> 
> The reasoning for this is that as we may not care about the gpio number
> for all pins, it should be optional. Would that work for you?
yes

but I was thinking to put it as a param but why not

my idea was this

pinctrl@fffff200 {
	#address-cells = <1>;
	#size-cells = <0>;
	compatible = "atmel,at91rm9200-pinctrl";

	atmel,mux-mask = <
		/*    A	  B     */
		 0xffffffff 0xffc003ff  /* pioA */
		 0xffffffff 0x800f8f00  /* pioB */
		 0xffffffff 0x00000e00  /* pioC */
		 0xffffffff 0xff0c1381  /* pioD */
		 0xffffffff 0x81ffff81  /* pioE */
		>;

	pioA: gpio@fffff200 {
		compatible = "atmel,at91rm9200-gpio";
		reg = <0xfffff200 0x100>;
		interrupts = <2 4>;
		#gpio-cells = <2>;
		gpio-controller;
		interrupt-controller;
	};

	pioB: gpio@fffff400 {
		compatible = "atmel,at91rm9200-gpio";
		reg = <0xfffff400 0x100>;
		interrupts = <3 4>;
		#gpio-cells = <2>;
		gpio-controller;
		interrupt-controller;
	};

	pioC: gpio@fffff600 {
		compatible = "atmel,at91rm9200-gpio";
		reg = <0xfffff600 0x100>;
		interrupts = <4 4>;
		#gpio-cells = <2>;
		gpio-controller;
		interrupt-controller;
	};

	pioD: gpio@fffff800 {
		compatible = "atmel,at91rm9200-gpio";
		reg = <0xfffff800 0x100>;
		interrupts = <5 4>;
		#gpio-cells = <2>;
		gpio-controller;
		interrupt-controller;
	};

	pioE: gpio@fffffa00 {
		compatible = "atmel,at91rm9200-gpio";
		reg = <0xfffffa00 0x100>;
		interrupts = <5 4>;
		#gpio-cells = <2>;
		gpio-controller;
		interrupt-controller;
	};

	dbgu {
		pins = < &pioB 12 0 0
			 &pioB 13 0 2 >;
	/* with macro */
		pins = < &pioB 12 MUX_A NO_PULL_UP
			 &pioB 13 MUX_A PULL_UP >;
	};

	/* and also the notion of linked group
	 * as on uart of network you have often the same subset of pin use.
	 *
	 * As example on uart rxd/txd is use for the group without rts/cts
	 * and the one with it
	 * on ethernet the RMII pin are use also on MII
	 */

	uart0_rxd_txd {
		pins = < &pioB 19 MUX_A PULL_UP		/* rxd */
			 &pioB 18 MUX_A NO_PULL_UP >;	/* txd */
	};

	uart0_rts_cts {
		groups = < &uart0_rxd_txd >;
		pins = < &pioB 17 MUX_B NO_PULL_UP	/* rts */
			 &pioB 15 MUX_B NO_PULL_UP >;	/* cts */
	};

	uart0_rts_cts_external_pull_up {
		groups = < &uart0_rts_cts >;
		gpios = <&pioC 1 0>;
	};
};

The idea is to avoid duplication the xlate for pins will be driver specific
with maybe a common implementation

the 3 or 4 first fix as done on gpio

Best Regards,
J.
