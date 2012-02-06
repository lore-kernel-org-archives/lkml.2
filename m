Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab2BFTGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:06:33 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:38100 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab2BFTGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:06:32 -0500
Message-ID: <4F302474.1020701@firmworks.com>
Date: Mon, 06 Feb 2012 09:05:24 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q16J5NeS005296 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like the general approach of simplifying the pinctrl thing, as the 
previous approach did not appear to be converging.

One possible name would be "gpconfig" - for general purpose configuration.

The register access model in the strawman proposal is probably too 
simple.  32-bit memory mapped registers are certainly the most common 
subcase on ARM, but there are many other cases that occur in practice:

* Registers that must be accessed with 8, 16, or 64-bit cycles.
* Registers that have side effects on read, so read-mask-write must be 
avoided
* Registers accessed via an index/data cycle pair, thus having locking 
requirements
* Registers that must be read after being written, or otherwise 
requiring some sort of memory-ordering enforcement.
* Time delays between pairs of writes
* PCI configuration registers, which often have some combination of the 
above
* Registers behind serial buses like I2C

Both Open Firmware and ACPI have addressed this general problem.  In 
addition to a numeric identifier for the register, you need to specify 
the access semantics.  It's difficult to finitely enumerate all possible 
cases, but you can get to 99.9% with a modest number of access models, 
and then add new models as needed.

