Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab2EVCPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:15:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53522 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab2EVCPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:15:20 -0400
Date: Tue, 22 May 2012 10:15:37 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DT clk binding support
Message-ID: <20120522021535.GG8140@S2101-09.ap.freescale.net>
References: <4FB80F32.5090309@gmail.com>
 <20120520030653.GB5810@S2100-06.ap.freescale.net>
 <4FB9A5E7.2070000@gmail.com>
 <20120521064901.GE8140@S2101-09.ap.freescale.net>
 <4FBA89E3.7010106@gmail.com>
 <20120521232616.GF8140@S2101-09.ap.freescale.net>
 <4FBAD545.7060803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBAD545.7060803@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 06:52:37PM -0500, Rob Herring wrote:
> As Grant states: "This proposed binding is only about one thing:
> attaching clock providers to clock consumers." This means you have to
> have at least a single provider and a single consumer defined in the DT.
> 
I just read through Grant's comments over again.  I agree with the
statement which implicitly requires the clk provider defined in DT.
However, for some case, this provider in DT is just a skeleton which
is backed by clock driver where the provider is actually defined.

Looking at Grant's comment below, the second option is also to match
the clock in driver just using name.  The only difference to my
proposal is the name here is given by the argument of phandle pointing
to that skeleton provider node.

I'm fine with that.  So go ahead with your bindings.

Regards,
Shawn

On Wed, Nov 16, 2011 at 03:12:50PM -0700, Grant Likely wrote:
> I'm really not convinced that it is a good idea to break out the
> entire clock tree into one node per struct clk.  To begin with, that
> looks to be very centric around the current 'struct clk' Linux
> abstraction, which is potentially in flux.  Also, looking at Sascha's
> initial RFC for describing the clock tree, I see cases where it looks
> like a clock nexus node really makes sense.  For instance, the
> 'divider-ipg <at> 0x53fd4014' node which has a list of child nodes
> which merely provide a register offset and shift value
> (reg=0x53fd4068..0x53fd4084, shift=0x0..0xf).  It would be natural to
> instead encode that as part of the clock reference, or map it directly
> from the clock reference (ie, assign names to each of the clocks, and
> let the clock provider driver match up the name to the reg offset &
> shift values).
>
> I had originally thought that it would be better to use names directly
> for references to clocks (ie. clock = <phandle>,"name") , but after
> actually playing with it and looking at the existing DT conventions,
> I've reverted to cell values for the arguments and a separate set of
> clock-{input,output}-name properties for attaching meaningful names,
> just like we decided to do for assigning names to 'reg' properties.
