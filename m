Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2LFV1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:27:30 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38458 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2LFV12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:27:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com>
References: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Dec 2012 14:27:06 -0700
Message-ID: <CAErSpo6xRdwzTuPPqnmvmHSp7awnV7=Z85eWFfktb_hm9Aad_A@mail.gmail.com>
Subject: Re: Sharing PCIE driver between Microblaze and Arm zynq
To: Michal Simek <michal.simek@xilinx.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arch@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        John Linn <John.Linn@xilinx.com>, John Williams <jwilliams@xilinx.com>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Thu, Dec 6, 2012 at 7:23 AM, Michal Simek <michal.simek@xilinx.com> wrote:
> Hi guys,
>
> I have a question regarding to sharing generic OF pcie driver between
> two architectures MB and ARM Zynq.
> Is drivers/pci/pcie location good for it?
> Make no sense to have the same driver in two locations.

I think you're talking about a PCI host bridge driver.  It would
definitely be nice to move toward a generic, shared driver.  Host
bridge drivers are responsible for enumerating the PCI hierarchy below
the bridge.  Enumeration is not really PCIe-specific, so I wouldn't
put it in drivers/pci/pcie.

> Is using readl/writel IO functions in this driver the best option
> which we can have?
> Or is there any other recommendation?

I'm not really a driver person, but if you're writing a new driver,
wouldn't you use the iomap interfaces (ioremap(), ioread32(), etc)
rather than readl()?

> Also just want to check if it is correct to use pcie device_type.

I don't know what you're asking here.  Can you elaborate or give a
specific example?

> The rest should be the same with pci description:
> (http://devicetree.org/MPC5200:PCI#PCI_Address_Translation).
