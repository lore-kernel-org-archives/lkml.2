Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab2AKTmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:42:19 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9567 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907Ab2AKTmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:42:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Jan 2012 11:41:57 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>
CC: Dong Aisheng <dongas86@gmail.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 11 Jan 2012 11:41:56 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczPlwPoC6af21G2TcKLc4ap2tt/xgBAZe1Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A74D@HQMAIL01.nvidia.com>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788508AC65@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120110130511.GA26599@S2101-09.ap.freescale.net>
In-Reply-To: <20120110130511.GA26599@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Tuesday, January 10, 2012 6:05 AM:
> On Tue, Jan 10, 2012 at 08:21:05AM +0000, Dong Aisheng-B29396 wrote:
> > Here what I wonder is that do we need to allow the platform to use a func-name
> > property in their pinmux func node or pinmux group node to specify the name.
> 
> I do not see the necessity.
> 
> > If it is allowed, then it could be flexible for soc to define their names.
> > If not there may be limitations on their node names since we can only get it from
> > the node name.
> 
> To me, the node name is perfectly fine to be used for that purpose.

I'd prefer if we could use integers over strings if at all possible, but
that does have a dependency on dtc getting a syntax to define named
constants, or the kernel pre-processing the .dts files before passing
them to dtc.

But if we have to use strings, I will point out that the pin names I
chose for Tegra may not be suitable as DT node names; I don't /think/
the DT node names can contain spaces, but I chose to name the Tegra
pinctrl pins after both their pin name and GPIO name so that it's
easier to correlate the two:

        PINCTRL_PIN(TEGRA_PIN_SDIO3_CLK_PA6, "SDIO3_CLK PA6"),

Now, I could change that, but I'd prefer not to.

-- 
nvpublic

