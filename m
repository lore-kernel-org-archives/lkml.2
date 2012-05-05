Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2EEC0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 22:26:07 -0400
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:47467 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750926Ab2EEC0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 22:26:06 -0400
Date: Sat, 5 May 2012 04:04:14 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tony Lindgren <tony@atomide.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120505020414.GJ7788@game.jcrosoft.org>
References: <20120502172401.GG3739@atomide.com>
 <20120503065131.GA3738@game.jcrosoft.org>
 <20120503152708.GC5140@atomide.com>
 <4FA30805.5050804@wwwdotorg.org>
 <20120504044305.GD7788@game.jcrosoft.org>
 <20120504150342.GI5140@atomide.com>
 <20120504153251.GE7788@game.jcrosoft.org>
 <20120504163420.GA5613@atomide.com>
 <4FA42631.6060304@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA42631.6060304@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10356308819837692749
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

On 12:55 Fri 04 May     , Stephen Warren wrote:
> On 05/04/2012 10:34 AM, Tony Lindgren wrote:
> > * Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120504 08:58]:
> >> On 08:03 Fri 04 May     , Tony Lindgren wrote:
> >>>>
> >>>> so I was thinking to do like on gpio
> >>>>
> >>>> uart {
> >>>> 	pin = < &pioA 12 {pararms} >
> >>>>
> >>>> }
> >>>
> >>> Hmm I assume the "12" above the gpio number?
> >> no pin number in the bank because it could not be gpio
> > 
> > Yes OK, but pin number 12 in the gpio bank, not in the mux register.
> > Got it.
> 
> I'd prefer to avoid any references to GPIOs here; not all muxable pins
> are GPIOs and not all GPIOs are muxable pins. Lets keep the two concepts
> independent.
my idea was to have a phandle pinctrl specific to represent the bank
and use it in the same way as done on gpio
> 
> >> 	pioD: gpio@fffff800 {
> >> 		compatible = "atmel,at91rm9200-gpio";
> >> 		reg = <0xfffff800 0x100>;
> >> 		interrupts = <5 4>;
> >> 		#gpio-cells = <2>;
> >> 		gpio-controller;
> >> 		interrupt-controller;
> >> 	};
> >>
> >> 	pioE: gpio@fffffa00 {
> >> 		compatible = "atmel,at91rm9200-gpio";
> >> 		reg = <0xfffffa00 0x100>;
> >> 		interrupts = <5 4>;
> >> 		#gpio-cells = <2>;
> >> 		gpio-controller;
> >> 		interrupt-controller;
> >> 	};
> >>
> >> 	dbgu {
> >> 		pins = < &pioB 12 0 0
> >> 			 &pioB 13 0 2 >;
> >> 	/* with macro */
> >> 		pins = < &pioB 12 MUX_A NO_PULL_UP
> >> 			 &pioB 13 MUX_A PULL_UP >;
> >> 	};
> > 
> > I could change to use this too no problem. The only concern I have is
> > that is "&pioB 12" immutable for all gpio controllers?
> 
> You mean is the number of cells used to specify a GPIO the same
> everywhere? No. It's defined by #gpio-cells in the GPIO controller node.
> 
> But again, the GPIO binding shouldn't be related to the pinctrl binding
> directly.
> 
> > Grepping the *.dts* files, at least exynos is using the following
> > for gpios:
> > 
> > gpios = <&gpx2 0 0 0 2>;
> > 
> > If we can conclude that phandle to the gpio controller instance and
> > the register offset is always enough here, then I'm OK changing to
> > that format. It would actually save some parsing in most cases.
> >  
> >> 	/* and also the notion of linked group
> >> 	 * as on uart of network you have often the same subset of pin use.
> >> 	 *
> >> 	 * As example on uart rxd/txd is use for the group without rts/cts
> >> 	 * and the one with it
> >> 	 * on ethernet the RMII pin are use also on MII
> >> 	 */
> >>
> >> 	uart0_rxd_txd {
> >> 		pins = < &pioB 19 MUX_A PULL_UP		/* rxd */
> >> 			 &pioB 18 MUX_A NO_PULL_UP >;	/* txd */
> >> 	};
> 
> I don't really see how that DT format represents pins, functions, and
> nodes directly, and separately from which of those a board chooses to
> use. I think this binding and the one Tony originally proposed are
> eseentially semantically identical.
> 
> Going back to my idea of separating SoC and board configurations, if we
> did that, I'd expect to see something more like:
> 
> soc.dtsi or board.dts:
> 
> This is the data that the pin controller driver needs to export to
> pinctrl core. This can be completely enumerated in the soc.dtsi, or
> perhaps for uncommonly used pins/groups/functions, only included in the
> board.dts that actually uses it to cut down on soc.dtsi's size:
> 
> This data is not needed for SoCs whose pinctrl drivers include it in
> their driver file instead of DT.
I agree on at91 I propose exactly this but get the following comment tat we
are going to have too much node.

so the idea I propoose with the pins array is to avoid this issue

my first bindings on at91

functions {
};

1) we describe one functin per pin

functions {
	rxd_pb12 {
		atmel,pin-id = <&pioB 12>;
		atmel,mux = <0>;
	};

	txd_pb13 {
		atmel,pin-id = <&piaB 13>;
		atmel,pull = <2>;
		atmel,mux = <0>;
	};

	txd0_pb19 {
		atmel,pin-id = <&pioB 19>;
		atmel,pull = <2>;
		atmel,mux = <0>;
	};

	rxd0_pb18 {
		atmel,pin-id = <&pioB 18>;
		atmel,mux = <0>;
	};

	rts0_pb17 {
		atmel,pin-id = <&pioB 17>;
		atmel,mux = <1>;
	};

	cts0_pb15 {
		atmel,pin-id = <&pioB 15>;
		atmel,mux = <1>;
	};
};

groups {
	dbgu {
		pinctrl,functions = <
			&rxd_pb12 &txd_pb13 >;
	};

	uart0_rxd_txd {
		pinctrl,functions = <
			&rxd0_pb18 &txd0_pb19 >;
	};

	uart0_rts_cts {
		pinctrl,functions = <
			&rxd0_pb18 &txd0_pb19
			&rts0_pb17 &cts0_pb15 >;
	};
};

Best Regards,
J.
