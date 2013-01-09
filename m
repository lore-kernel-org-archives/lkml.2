Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229Ab3AIVZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:25:31 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:49089 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515Ab3AIVZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:25:25 -0500
Date: Wed, 9 Jan 2013 22:25:17 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 00/14] Rewrite Tegra PCIe driver
Message-ID: <20130109222517.3c590553@skate>
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thierry Reding,

On Wed,  9 Jan 2013 21:43:00 +0100, Thierry Reding wrote:
> This patch series contains an almost complete rewrite of the Tegra PCIe
> driver. The code is moved to the drivers/pci/host directory and turned
> into a proper platform driver, adding MSI and DT support while at it.
> Other PCI host controller drivers can be added to that directory in an
> attempt to make it easier to factor out common code.

Thanks!

I have started basing the Marvell PCIe code on some of your earlier
versions. But apparently in this final version, you no longer have the
emulated Host bridge. Why so?

For the Marvell PCIe code, I've used your emulated Host bridge, and
added an emulated PCI-to-PCI bridge implementation, in order to get the
following hierarchy:

 + Host Bridge
   + PCI-to-PCI bridge
     + PCI Device
   + PCI-to-PCI bridge
     + PCI device

So, I instantiate one unique emulated Host Bridge, and then one
emulated PCI-to-PCI Bridge for each PCIe interface that I have.

The nice thing about that is that I can then read the configuration
space of the PCI-to-PCI bridge to find out how much I/O space and
memory space is needed for the device connected to this interface, and
at which address is has been mapped. This greatly helps my "address
decoding" problem, and removes the ad-hoc virtual space allocator I had
written.

Is there a reason for having given up on this idea? Is there still a
hope for a different PCIe implementation to use this idea?

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
