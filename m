Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab1ESQdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:33:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33167 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab1ESQdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:33:21 -0400
Date: Thu, 19 May 2011 12:33:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: dgdegra@tycho.nsa.gov
Subject: [GIT PULL] (xen) stable/backend.base.v3 stable/gntalloc.v7 for 2.6.40
Message-ID: <20110519163303.GA13186@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4DD5464D.006B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus

Please git pull:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/backend.base.v3 stable/gntalloc.v7

where stable/backend.base.v3 is based off v2.6.39-rc3
(a6360dd37e1a144ed11e6548371bade559a1e4df)
This particular patchset touches a lot of Xen code in different directories,
which I could have avoided by splitting the patches in different branches.
However for simplicity reasons (one branch name so much easier to keep in mind)
I stuck them all in this branch.

The patchset does a couple of things:
 - Allows the Xen's Machine to Frame Number (MFN) to Page Frame Number (PFN)
   override mechanism (which we as a way to share pages with other guests)
   to work with other backends. The other backend right now is the block
   backend, but can also be the network backend.
 - Fixes compile errors if backends are compiled as modules.
 - Lays out the groundwork for the PCI backend to remember which of the PCI
   devices are assigned to a guest if the pci backend is used.
 - Lastly, exposes some of the Xen's IRQ lookup code to the pci backend so
   that the correct Physical IRQ (GSI or vector if MSI/MSI-X used) is
   provided to the guest.

The #stable/gntalloc.v7 is based of .. 38eaeb0fd8819dce424a61579500bd9987d5c930
(xen: gntdev: fix build warning), which went in at the beginning of 2.6.39.
Anyhow, it just removes an unneeded flag.

The full diffstat:

 arch/x86/include/asm/xen/page.h |    5 +-
 arch/x86/include/asm/xen/pci.h  |   16 +++++++
 arch/x86/pci/xen.c              |   96 +++++++++++++++++++++++++++++++++++++--
 arch/x86/xen/p2m.c              |   13 +++---
 drivers/xen/events.c            |   39 ++++++++++++++--
 drivers/xen/gntalloc.c          |   14 +++++-
 drivers/xen/gntdev.c            |   16 ++++++-
 drivers/xen/grant-table.c       |   31 ++++++++++---
 include/xen/events.h            |    9 +++-
 9 files changed, 208 insertions(+), 31 deletions(-)

Daniel De Graaf (1):
      xen/gntdev,gntalloc: Remove unneeded VM flags

Konrad Rzeszutek Wilk (8):
      xen/pci: Add xen_[find|register|unregister]_device_domain_owner functions.
      xen/irq: Check if the PCI device is owned by a domain different than DOMID_SELF.
      xen/irq: Add support to check if IRQ line is shared with other domains.
      xen/irq: Export 'xen_pirq_from_irq' function.
      xen/irq: The Xen hypervisor cleans up the PIRQs if the other domain forgot.
      xen/p2m/m2p/gnttab: Support GNTMAP_host_map in the M2P override.
      xen/p2m: Add EXPORT_SYMBOL_GPL to the M2P override functions.
      xen/pci: Fix compiler error when CONFIG_XEN_PRIVILEGED_GUEST is not set.

