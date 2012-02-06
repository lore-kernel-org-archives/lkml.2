Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab2BFS50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:57:26 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:41829 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2BFS5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:57:25 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/LD8ZP8BPDAQc8WG95Ha/Q
Date: Mon, 6 Feb 2012 10:57:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
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
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
Message-ID: <20120206185711.GT1426@atomide.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@nvidia.com> [120204 21:01]:
> Sorry, I haven't had a chance to read any of the pincrl emails from
> Friday onwards. However, I thought a bit more about this, and decided
> to propose someting much simpler:
> 
> Thoughts:
> 
> * Defining all the pins, groups, functions, ... takes a lot of space,
>   whether it's in static data in pinctrl drivers or in the device tree.
>   The lists must also be stored in RAM at runtime.
> 
> * It's been very difficult to come up with a generic description of all
>   pin controller's capabilities. This is true even irrespective of device
>   tree; think pin config where we've agonized over whether we can create
>   a standardized list of pin config properties, or need to allow each
>   pinctrl driver to define its own set of properties, etc.
> 
> * The only real use of the lists is for debugfs. Drivers shouldn't expect
>   to directly request specific pinctrl settings, since that would encode
>   knowledge of an individual SoC's pin controller. This should be
>   abstracted from drivers.
> 
> * The data in debugfs could easily be replaced by a raw register dump
>   coupled with a SoC-specific script to print out what each register
>   means.

My conclusions are pretty much the same: The data is only needed in
the driver for debugging. And the register names and values are best
translated into readable format using debugfs and userspace tools.

I pretty much did this with the pinctrl-simple.c I posted few days
ago, except no userspace debugging support yet in pinctrl framework
naturally.

This all seems to fit into the current pinctrl framework OK.

I think we just need to make string names optional data, and
structure things in debugfs to just display register physical
addresses rather than string names for userspace tools.

FYI, I'm currently working around the names by using the hex
register physical address as the pin name.

Also, the alternative pin modes bindings still needs to be
discussed, so maybe we all can talk about that at Linaro Connect
on Tuesday at some point.

Regards,

Tony
