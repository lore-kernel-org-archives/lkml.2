Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2IROu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 10:50:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52969 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2IROu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 10:50:28 -0400
Date: Tue, 18 Sep 2012 15:50:18 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v4 06/24] docs: Xen ARM DT bindings
Message-ID: <20120918145012.GA2110@linaro.org>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com>
 <1347621207-11294-6-git-send-email-stefano.stabellini@eu.citrix.com>
 <20120914130151.GH25249@phenom.dumpdata.com>
 <alpine.DEB.2.02.1209141514590.29232@kaball.uk.xensource.com>
 <50572692.1090805@gmail.com>
 <alpine.DEB.2.02.1209171508470.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209171508470.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 03:12:11PM +0100, Stefano Stabellini wrote:
> On Mon, 17 Sep 2012, Rob Herring wrote:
> > On 09/14/2012 09:26 AM, Stefano Stabellini wrote:
> > > On Fri, 14 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > >> On Fri, Sep 14, 2012 at 12:13:08PM +0100, Stefano Stabellini wrote:
> > >>> Add a doc to describe the Xen ARM device tree bindings
> > >>>
> > >>>
> > >>> Changes in v4:
> > >>>
> > >>> - "xen,xen" should be last as it is less specific;
> > >>> - update reg property using 2 address-cells and 2 size-cells.
> > >>>
> > >>>
> > >>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > >>> CC: devicetree-discuss@lists.ozlabs.org
> > >>> CC: David Vrabel <david.vrabel@citrix.com>
> > >>> CC: Rob Herring <robherring2@gmail.com>
> > >>> CC: Dave Martin <dave.martin@linaro.org>
> > >>> ---
> > >>>  Documentation/devicetree/bindings/arm/xen.txt |   22 ++++++++++++++++++++++
> > >>>  1 files changed, 22 insertions(+), 0 deletions(-)
> > >>>  create mode 100644 Documentation/devicetree/bindings/arm/xen.txt
> > >>>
> > >>> diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
> > >>> new file mode 100644
> > >>> index 0000000..1f8f7d4
> > >>> --- /dev/null
> > >>> +++ b/Documentation/devicetree/bindings/arm/xen.txt
> > >>> @@ -0,0 +1,22 @@
> > >>> +* Xen hypervisor device tree bindings
> > >>> +
> > >>> +Xen ARM virtual platforms shall have the following properties:
> > >>> +
> > 
> > State that they are part of top-level "hypervisor" node.
> 
> OK
> 
> 
> > >>> +- compatible:
> > >>> +	compatible = "xen,xen-<version>", "xen,xen";
> > >>> +  where <version> is the version of the Xen ABI of the platform.
> > >>> +
> > >>> +- reg: specifies the base physical address and size of a region in
> > >>> +  memory where the grant table should be mapped to, using an
> > >>> +  HYPERVISOR_memory_op hypercall. 
> > >>> +
> > >>> +- interrupts: the interrupt used by Xen to inject event notifications.
> > >>
> > >> Its singular here.. but in the example its plurar. What if you use
> > >> multiple of the same number ("16 0xf")?
> > > 
> > > The "interrupts" property in the example below is a standard property to
> > > describe interrupts. We just happen to declare only one interrupt.
> > > 
> > > From the device tree point of view it would be possible to declare more
> > > than one interrupt here, but Xen only supports one really.
> > > 
> > > Regarding the three cells used in the example (<1 15 0xf08>), they have
> > > a specific meaning in the GIC context:
> > > 
> > > """
> > >   The 1st cell is the interrupt type; 0 for SPI interrupts, 1 for PPI
> > >   interrupts.
> > > 
> > >   The 2nd cell contains the interrupt number for the interrupt type.
> > >   SPI interrupts are in the range [0-987].  PPI interrupts are in the
> > >   range [0-15].
> > > 
> > >   The 3rd cell is the flags, encoded as follows:
> > > 	bits[3:0] trigger type and level flags.
> > > 		1 = low-to-high edge triggered
> > > 		2 = high-to-low edge triggered
> > > 		4 = active high level-sensitive
> > > 		8 = active low level-sensitive
> > > 	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
> > > 	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
> > > 	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
> > > """
> > > 
> > > So <1 15 0xf08> means the last PPI.
> > 
> > Since it is a PPI, it is handled differently than a normal interrupt.
> > That is fine, but you should somehow state that a GIC node is also required.
> 
> Yes, good idea
> 
> 
> > >>> +
> > >>> +
> > >>> +Example:
> > >>> +
> > >>> +hypervisor {
> > >>> +	compatible = "xen,xen-4.3", "xen,xen";
> > >>> +	reg = <0 0xb0000000 0 0x20000>;
> > >>
> > >> So two grant tables?
> > >>
> > >> Hm, physical address is zero, and the size is 0xbignumber?
> > >> Or is the '0' denotating a seperator of arguments, so it is
> > >> 0xb000.. for physical address and 0x20000 for size?
> > > 
> > > from http://devicetree.org/Device_Tree_Usage:
> > > 
> > > "Each addressable device gets a reg which is a list of tuples in the
> > > form reg = <address1 length1 [address2 length2] [address3 length3] ...
> > > Each tuple represents an address range used by the device. Each address
> > > value is a list of one or more 32 bit integers called cells. Similarly,
> > > the length value can either be a list of cells, or empty."
> > > 
> > > In this case the address is: [0 0xb0000000], that means
> > > 0x00000000b0000000, and the length is [0 0x20000], that means
> > > 0x0000000000020000.
> > 
> > But the size depends on #size-cells and #address-cells. I would expect
> > those to be 1 for a 32-bit guest.
>  
> I was looking at the Versatile Express DTS (vexpress-v2p-ca15-tc1.dts)
> that on Linux v3.6-rc5 has:
> 
> #address-cells = <2>;
> #size-cells = <2>;

Some core tiles on vexpress use physical addresses beyond 4G.  But many
32-bit platforms (including some supporting the virtualization extensions)
may not.  There's no reason for such platforms to set these properties to
<2>.

> What should I use for the example in this doc?

Looking at other files in Documentation/device-tree/bindings/, it looks
like the common  example configuration is for #address-cells and
#size-cells to be 1.

So, assuming that those are 1 is probably best for examples.

You could state this explicitly for good measure, but the need to
expand reg properties (and other related properties) to match the parent
bus #address-cells and #size-cells is a standard device-tree concept, so
I think it doesn't make sense to describe the implications in detail on
a per-binding basis.

Cheers
---Dave
