Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab2ALHkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 02:40:46 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:53765
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab2ALHkp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 02:40:45 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1432Nzz1202hzzz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>, Stephen Warren <swarren@nvidia.com>
CC: Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AQHMvzz/OIptPg50WkeChzdBCJw49JXl2BOAgAA9DlCABdN5oIASXrkAgAC9bACAAEFboIAAbmbAgAG5cQCABpLFAIAAnRCA///Ze+A=
Date: Thu, 12 Jan 2012 07:40:40 +0000
Message-ID: <7FE21149F4667147B645348EC605788508E6A8@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <20120107135445.GI4790@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A6E5@HQMAIL01.nvidia.com>
 <20120112033941.GH20968@S2101-09.ap.freescale.net>
In-Reply-To: <20120112033941.GH20968@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...
> > * The enumerations above should be purely at the level the HW exposes,
> > i.e. if a UART uses 4 signals (RX, TX, CTS, RTS), and the SoC
> > configures muxing at a per-pin level, and 6 pins exist which can have
> > various UART signals mux'd on to them, there should be a "muxable
> > entity" enumeration for each of the 6 pins, not an enumeration for
> > each possible combination of assignments of signals to pins, since in
> > general that number could be extremely large as Richard Zao points out
> > in his email that was sent right after yours.
> >
> Speaking of the model, yes, it's true.  But coming to the practical
> implementation, we may need compromise on whether we need to do a full
> enumeration.
> 
> > * pinmux properties in device drivers should list the muxable entities
> > that they use, and the mux function for each of them.
> >
> Following on the example above, we will need something below in SD node to
> specify each pin and corresponding function selection.
> 
>         usdhc@02194000 { /* uSDHC2 */
>                 #pinmux-cells = <2>;
>                 // The second cell specify the index of the desired function of
> given pin
>                 pinmux = < &sd2_dat1 0
>                            &sd2_dat2 0
>                            ...        >;
>                 status = "okay";
>         };
> 
> IMO, it's not nice for pinctrl client devices.  Though it's true that the
> muxable entity is pin, what the client device really cares is its pingroup.  We
> should define the pingroup rather than pin for client device to refer to with a
> phandle.  This is just like that pinctrl subsystem api pinmux_get/enable operate
> on a pingroup as an interface to client device driver, no matter the muxable
> entity at HW level is a pin or a group.
> 
+1
It's just like what the current pinctrl subsystem does:
the device says "I'm using this function and this pin group, please enable!"
But no pins are specified.

Regards
Dong Aisheng

