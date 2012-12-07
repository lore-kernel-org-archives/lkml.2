Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab2LGNRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 08:17:15 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53344 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030310Ab2LGNRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 08:17:12 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Sharing PCIE driver between Microblaze and Arm zynq
To: Michal Simek <michal.simek@xilinx.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arch@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: John Linn <John.Linn@xilinx.com>, John Williams <jwilliams@xilinx.com>
In-Reply-To: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com>
References: <CAHTX3dLxbVxn+D+AV7L0VsGYFOjas3AJ_3M_xncVfxp02FCy=Q@mail.gmail.com>
Date: Fri, 07 Dec 2012 13:17:06 +0000
Message-Id: <20121207131706.EC9273E0B87@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012 15:23:14 +0100, Michal Simek <michal.simek@xilinx.com> wrote:
> Hi guys,
> 
> I have a question regarding to sharing generic OF pcie driver between
> two architectures MB and ARM Zynq.
> Is drivers/pci/pcie location good for it?
> Make no sense to have the same driver in two locations.
> Is using readl/writel IO functions in this driver the best option
> which we can have?
> Or is there any other recommendation?
> 
> Also just want to check if it is correct to use pcie device_type.
> The rest should be the same with pci description:
> (http://devicetree.org/MPC5200:PCI#PCI_Address_Translation).

Yes. device_type may be deprecated, but the PCI binding predates that.
PowerPC uses pcie in the device type. arch/powerpc/kernel/of_platform.c

Some of that powerpc DT PCI support code really should be made generic.

g.

