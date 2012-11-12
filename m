Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2KLRAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:00:24 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:52697 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab2KLRAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:00:21 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50A128AF.1010803@wwwdotorg.org>
Date: Mon, 12 Nov 2012 19:00:13 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <7C181180-2FE7-4EE4-BB5A-D7A1ACEC4244@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <C3971D11-2BAC-4B58-AF8D-987FF8FFF678@antoniou-consulting.com> <50A128AF.1010803@wwwdotorg.org>
To: Stephen Warren <swarren@wwwdotorg.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Nov 12, 2012, at 6:49 PM, Stephen Warren wrote:

> On 11/12/2012 04:23 AM, Pantelis Antoniou wrote:
>> Hi Grant,
>> 
>> Sorry for the late comments, travelling...
>> 
>> On Nov 9, 2012, at 6:28 PM, Grant Likely wrote:
> ...
>>> *with the caveat that not all types of changes are a good idea and we
>>> may disallow. For example, is changing properties in existing nodes a
>>> good idea?
>> 
>> Yes, changing properties is something that we need. One such change is
>> the change of the bus controller 'status' properties to enabled upon
>> insertion of a child device node, and change back to 'on-demand' when
>> all the child device nodes are gone.
> 
> Do we actually need to do that?
> 
> From the base-board perspective, consider an SoC's I2C channel that is
> routed to the child board connector. The routing to the connector is
> always present on the base board. Only the presence (or lack thereof) of
> devices on that I2C bus is influenced by whether a child board is
> connected or not, and the design of the child board. Therefore, wouldn't
> it make sense for the base board to always enable the I2C controller?
> 
> That would make it easier for someone to hook up a couple wires to the
> I2C pins and use utilities such as i2cget/set to communicate with it,
> without going through the whole process of creating a DT to represent
> the device. This could speed up simple hacking/prototyping and allow it
> to proceed in a less structured way.

Unfortunately that doesn't work for the beaglebone (am355x) and a large
number of general purpose SoCs.

What is different between general purpose SoCs and vertical market SoCs
(i.e. OMAP) is that the design of the the latter is for devices where
pretty much all the interfaces are expected to be active at the same time.

General purpose SoCs put more peripherals in the SoC, but due to packaging
considerations (and price), the peripheral pins are highly muxed.

So the i2c bus pins are shared with the LCD controller are shared with the
analog input and so on.

It is impossible (and on top of that really dangerous) to enable peripheral
blocks without knowing what's connected on the other side.

In a nutshell, for the bone and similar devices, probing with the devices
enabled doesn't work.

Regards

-- Pantelis
  
