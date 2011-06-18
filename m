Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1FRQ1C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 12:27:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38663 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1FRQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 12:26:59 -0400
Date: Sat, 18 Jun 2011 10:26:55 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        patches@linaro.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Jason Liu <jason.hui@linaro.org>,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
Message-ID: <20110618162655.GK8195@ponder.secretlab.ca>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org>
 <201106181821.46574.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106181821.46574.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 18, 2011 at 06:21:46PM +0200, Arnd Bergmann wrote:
> On Saturday 18 June 2011 17:19:12 Shawn Guo wrote:
> >
> > +Required properties:
> > +- compatible : should be "fsl,<soc>-uart", "fsl,imx-uart"
> > +- reg : address and length of the register set for the device
> > +- interrupts : should contain uart interrupt
> > +- id : should be the port ID defined by soc
> > +
> > +Optional properties:
> > +- fsl,has-rts-cts : indicate it has rts-cts
> > +- fsl,irda-mode : support irda mode
> > +
> > +Example:
> > +
> > +uart@73fbc000 {
> > +	compatible = "fsl,imx51-uart", "fsl,imx-uart";
> > +	reg = <0x73fbc000 0x4000>;
> > +	interrupts = <31>;
> > +	id = <1>;
> > +	fsl,has-rts-cts;
> > +};
> 
> Should this also support the "clock-frequency" property that 8250-style
> serial ports support [1]?
> 
> For the flow-control properties, should we name that more generic? The
> same property certainly makes sense for other serial-ports if it does
> here. OTOH, I'm not sure it's actually reliable, because it also depends
> on whether the other side of the connection and the cable support hw flow
> control.

I'd like to see a few use cases before defining a common property.
That said, has-rts-cts does sound like a useful generic property.
Or maybe named "uart-has-rts-cts" to make it clear that it is a uart
specific binding?

g.

> 
> 
> 	Arnd
> 
> [1] http://playground.sun.com/1275/bindings/devices/html/serial-1_0d.html#HDR9
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
