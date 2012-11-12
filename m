Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2KLQt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:49:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51257 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2KLQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:49:56 -0500
Message-ID: <50A128AF.1010803@wwwdotorg.org>
Date: Mon, 12 Nov 2012 09:49:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <CACxGe6v=+8UKerzp9z5cZo6TbXJQ4Nb=fpKgfkuvib_B-BoVdw@mail.gmail.com> <C3971D11-2BAC-4B58-AF8D-987FF8FFF678@antoniou-consulting.com>
In-Reply-To: <C3971D11-2BAC-4B58-AF8D-987FF8FFF678@antoniou-consulting.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 04:23 AM, Pantelis Antoniou wrote:
> Hi Grant,
> 
> Sorry for the late comments, travelling...
> 
> On Nov 9, 2012, at 6:28 PM, Grant Likely wrote:
...
>> *with the caveat that not all types of changes are a good idea and we
>> may disallow. For example, is changing properties in existing nodes a
>> good idea?
> 
> Yes, changing properties is something that we need. One such change is
> the change of the bus controller 'status' properties to enabled upon
> insertion of a child device node, and change back to 'on-demand' when
> all the child device nodes are gone.

Do we actually need to do that?

>From the base-board perspective, consider an SoC's I2C channel that is
routed to the child board connector. The routing to the connector is
always present on the base board. Only the presence (or lack thereof) of
devices on that I2C bus is influenced by whether a child board is
connected or not, and the design of the child board. Therefore, wouldn't
it make sense for the base board to always enable the I2C controller?

That would make it easier for someone to hook up a couple wires to the
I2C pins and use utilities such as i2cget/set to communicate with it,
without going through the whole process of creating a DT to represent
the device. This could speed up simple hacking/prototyping and allow it
to proceed in a less structured way.
