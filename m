Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2AQTc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:32:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18438 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2AQTc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:32:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 17 Jan 2012 11:32:38 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
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
Date: Tue, 17 Jan 2012 11:32:37 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczVIJuR6M6/OONiRKSQ5bBSGnP4VQALapVQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D22FA@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117141322.GA31687@S2101-09.ap.freescale.net>
In-Reply-To: <20120117141322.GA31687@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Tuesday, January 17, 2012 7:13 AM:
> On Tue, Jan 17, 2012 at 09:46:42AM +0000, Dong Aisheng-B29396 wrote:
> ...
> > I guess Stephen's idea is to retrieving the function name and group name
> > From the pinctrl driver since Tagre prefers to define those things in driver
> > Rather than in board file or soc.dts file.
> > But it does not fit for IMX since we define it in soc.dts.
>
> Hmm, when he came up with this proposal and said it should work for
> Tegra, I assume he plans to move those from Tegra pinctrl driver into
> device tree.  Stephen?

I plan to have the following:

tegra20.dtsi:

A regular device node for the pin controller, listing just the basic
device tree properties: "compatible" and "regs".

${board}.dts:

Each device node lists its pin mux/config setup using the bindings we
decide upon.

drivers/pinctrl/pinctrl-tegra20.c:

Static tables listing all pins, pin groups, mux functions, and pin
configuration options that Tegra supports.

-- 
nvpublic

