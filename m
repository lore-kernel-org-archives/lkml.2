Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030698Ab2LGOLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:11:23 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54890 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab2LGOLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:11:20 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Sharing PCIE driver between Microblaze and Arm zynq
To: monstr@monstr.eu, Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arch@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        John Linn <John.Linn@xilinx.com>, John Williams <jwilliams@xilinx.com>,
        linux-pci@vger.kernel.org
In-Reply-To: <50C1BA9D.5010406@monstr.eu>
References: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com> <CAErSpo6xRdwzTuPPqnmvmHSp7awnV7=Z85eWFfktb_hm9Aad_A@mail.gmail.com> <50C1BA9D.5010406@monstr.eu>
Date: Fri, 07 Dec 2012 14:11:15 +0000
Message-Id: <20121207141115.EFC903E0B87@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2012 10:45:01 +0100, Michal Simek <monstr@monstr.eu> wrote:
> On 12/06/2012 10:27 PM, Bjorn Helgaas wrote:
> > [+cc linux-pci]
> >
> > On Thu, Dec 6, 2012 at 7:23 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> >> Hi guys,
> >>
> >> I have a question regarding to sharing generic OF pcie driver between
> >> two architectures MB and ARM Zynq.
> >> Is drivers/pci/pcie location good for it?
> >> Make no sense to have the same driver in two locations.
> >
> > I think you're talking about a PCI host bridge driver.  It would
> > definitely be nice to move toward a generic, shared driver.  Host
> > bridge drivers are responsible for enumerating the PCI hierarchy below
> > the bridge.  Enumeration is not really PCIe-specific, so I wouldn't
> > put it in drivers/pci/pcie.
> 
> Not a PCI expert, just trying to find out the proper location for this shared driver.
> 
> 
> >> Is using readl/writel IO functions in this driver the best option
> >> which we can have?
> >> Or is there any other recommendation?
> >
> > I'm not really a driver person, but if you're writing a new driver,
> > wouldn't you use the iomap interfaces (ioremap(), ioread32(), etc)
> > rather than readl()?
> 
> That driver exists but it is not in mainline and it is better to directly
> add it to proper location with correct io functions.
> The question is if ioread/iowrite functions are correct one.
> PowerPC io-defs.h suggests that readl/writel should be used for PCI.
> 
> 
> >> Also just want to check if it is correct to use pcie device_type.
> >
> > I don't know what you're asking here.  Can you elaborate or give a
> > specific example?
> 
> If node property device_type pcie should be used.
> device_type = "pcie";
> 
> For pci it is device_type = "pci";
> For network it is device_type = "network"
> the same for serial, watchdogs.
> 
> Do we have any list of device_types which we should use?

Don't use them unless a binding requires it. PCI address lookup code
uses it, so we put it in those nodes. Otherwise device_type is
deprecated and has been for a long time now. You should not be using it
in .dts files.

g.

