Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab2ATVP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:15:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9073 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2ATVP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:15:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 20 Jan 2012 13:15:35 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>,
        Thomas Abraham <thomas.abraham@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Fri, 20 Jan 2012 13:15:34 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczWy0G7NGRV07kRS1G6vb2NDYPnIgA7PdJg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB47A@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <CAJuYYwQoh4_SnA9wmy4x+cG0w0hGukxTkODWtcSw_2QHYuDsrg@mail.gmail.com>
 <20120119165607.GG22818@atomide.com>
In-Reply-To: <20120119165607.GG22818@atomide.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren wrote at Thursday, January 19, 2012 9:56 AM:
> * Thomas Abraham <thomas.abraham@linaro.org> [120119 04:37]:
...
> > * Specifying the pinmux/pinconfig settings in dts files:
> >
> > Device nodes which require specific pinmux/pinconfig settings should
> > include information about the required settings. For example, a i2c
> > controller node in dts file is listed below.
> >
> > i2c0: i2c@18000000 {
> >         [... other properties ...]
> >         pinctrl-active = <&pctrl0 5 0 2 3 0>,
> >                              <&pctrl0 5 1 2 3 0>;
> >         pinctrl-suspend = <&pctrl0 5 0 2 0 0>,
> >                                 <&pctrl0 5 1 2 0 0>;
> > };
> 
> Maybe we should have just the active/suspend/off flags in the
> same array? Otherwise we'll end up unnecessarily repeating the
> the pin information. See the pins + #pin-args example I posted,
> which is otherwise similar.

Earlier discussions in this thread have discussed how to share common
settings between the various named states, by allowing the device to
refer to multiple properties or nodes for each named state; roughly:

foo@c8000200 {
   ...
   pinctrl = <&pinmux_foo> <&pinmux_foo_extra>
             <&pinmux_foo_suspend> <&pinmux_foo_extra_suspend>;
   pinctrl-entries = <2 2>;
   pinctrl-names = "active", "suspend";
};

I'll describe this more completely in my V2 bindings proposal.

-- 
nvpublic

