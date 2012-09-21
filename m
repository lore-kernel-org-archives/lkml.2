Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2IUSVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:21:21 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33311 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2IUSVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:21:19 -0400
Date: Fri, 21 Sep 2012 14:23:02 -0400
From: Matt Porter <mporter@ti.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 05/13] dma: Add TI EDMA device tree binding
Message-ID: <20120921182302.GF16522@beef>
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-6-git-send-email-mporter@ti.com>
 <1BAFE6F6C881BF42822005164F1491C33EA8A819@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA8A819@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 08:45:53AM +0000, Hebbar, Gururaja wrote:
> On Thu, Sep 20, 2012 at 20:13:38, Porter, Matt wrote:
> > The binding definition is based on the generic DMA controller
> > binding.
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  Documentation/devicetree/bindings/dma/ti-edma.txt |   49 +++++++++++++++++++++
> >  1 file changed, 49 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/dma/ti-edma.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt b/Documentation/devicetree/bindings/dma/ti-edma.txt
> > new file mode 100644
> > index 0000000..06402eb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
> > @@ -0,0 +1,49 @@
> > +TI EDMA
> > +
> > +Required properties:
> > +- compatible : "ti,edma3"
> > +- ti,hwmods: Name of the hwmods associated to the EDMA
> > +- ti,edma-regions: Number of regions
> > +- ti,edma-slots: Number of slots
> > +- ti,edma-queue-tc-map: List of transfer control to queue mappings
> > +- ti,edma-queue-priority-map: List of queue priority mappings
> > +- ti,edma-default-queue: Default queue value
> > +
> > +Optional properties:
> > +- ti,edma-reserved-channels: List of reserved channel regions
> > +- ti,edma-reserved-slots: List of reserved slot regions
> > +
> > +Example:
> > +
> > +edma: edma@49000000 {
> > +	#address-cells = <1>;
> > +	#size-cells = <0>;
> 
> address-cells & size-cells are only required when current node is a parent 
> node & it has sibling/child nodes (that too if the child node uses "reg" 
> property).

Ok. will drop that in v2.

> 
> 
> > +	reg = <0x49000000 0x10000>;
> > +	interrupt-parent = <&intc>;
> > +	interrupts = <12 13 14>;
> > +	compatible = "ti,edma3";
> > +	ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> > +	#dma-cells = <1>;
> > +	dma-channels = <64>;
> > +	ti,edma-regions = <4>;
> > +	ti,edma-slots = <256>;
> > +	ti,edma-reserved-channels = <0  2
> > +				     14 2
> > +				     26 6
> > +				     48 4
> > +				     56 8>;
> > +	ti,edma-reserved-slots = <0  2
> > +				  14 2
> > +				  26 6
> > +				  48 4
> > +				  56 8
> > +				  64 127>;
> > +	ti,edma-queue-tc-map = <0 0
> > +				1 1
> > +				2 2>;
> > +	ti,edma-queue-priority-map = <0 0
> > +				      1 1
> > +				      2 2>;
> > +	ti,edma-default-queue = <0>;
> > +};
> > +
> > -- 
> > 1.7.9.5
> > 
> > _______________________________________________
> > Davinci-linux-open-source mailing list
> > Davinci-linux-open-source@linux.davincidsp.com
> > http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> > 
> 
> 
> Regards, 
> Gururaja
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
