Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2KFSfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 13:35:48 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33451 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751061Ab2KFSfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 13:35:46 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+bATrYMFmEUAsc/QAo4I2a
Date: Tue, 6 Nov 2012 10:35:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        linux-omap@vger.kernel.org, Kevin Hilman <khilman@ti.com>,
        Paul Walmsley <paul@pwsan.com>, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving
 omap_devices to mach-omap2)
Message-ID: <20121106183531.GH6801@atomide.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com>
 <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com>
 <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6vDzmPWsOZ53HTwkYmDEivg9TpnRrvudY2FK95V06O24w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [121106 03:16]:
> On Tue, Nov 6, 2012 at 10:30 AM, Pantelis Antoniou
> <panto@antoniou-consulting.com> wrote:
> >
> > Another can of worms is the pinctrl nodes.
> 
> Yes... new pinctrl data would need to trigger adding new data to
> pinctrl. I don't know if the pinctrl api supports that.

The actual pins stay the same, just their configuration
changes. AFAIK all that is already supported using the
pinctrl framework.

For example, considering hotplugging capes on the beaglebone:

1. You need to map all the sensible modes for the pins exposed
   to the capes in the board specific .dts file. This will
   add roughly 4 x nr_capbus_pins named modes in the .dts file
   so not too bad.

2. Claim all the capebus pins during the capbus driver probe
   and set them to some safe mode.

3. Try to detect the connected cape(s) over i2c.

4. Use pinctr_select_state to set the desired modes for
   the pins used by the cape(s).

5. Enable capebus regulators and clocks etc.

6. Load the driver modules for whatever omap internal
   devices the cape supports.

You could also claim the pin for the omap internal
devices instead of claiming them in the capebus, but then
things can get messy with binding and unbinding the
drivers. So just claiming all the pins in the capebus
probably keeps things simpler.

Regards,

Tony
