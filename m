Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2E3UIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:08:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2E3UIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:08:46 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 0/5] PCI: Prep for VFIO and IOMMU Groups
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, konrad.wilk@oracle.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        shangw@linux.vnet.ibm.com, liuj97@gmail.com
Date: Wed, 30 May 2012 14:08:15 -0600
Message-ID: <20120530200343.31085.78920.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
 - Test that we're not given func 0 before doing lookup
 - Fix duplicate ricoh quirk
 - Rename pci_dma_source() to pci_get_dma_source() and make sure
   we always take a reference for the returned pci_dev.  Add comment

These last two changes trickle down through the IOMMU series, so
will generate a v2 there as well.  Thanks,

Alex

v1:
These are the PCI related patches from the previously submitted
v2 IOMMU Groups + VFIO series.  I've updated them with Don's
comments and split them off on their own so that we can hopefully
make some progress getting these in.  Patches are against 20120529
linux-next tree.

Patches 1 & 2 provide DMA quirking and ACS checking which will be
used by IOMMU drivers supporting IOMMU groups.  Patch 3 enables the
set of pci user config access functions to be called from other
modules, which will be used by VFIO-pci.  Patch 4 enables a common
translation of pcibios errors into errno for returning to userspace,
also to be used by VFIO-pci.  Patch 5 adds additional PCI register
definitions so we can more easily parse config space for devices in
VFIO-pci.

These patches, as well as IOMMU group support and VFIO can be
found in git here:

git://github.com/awilliam/linux-vfio.git (iommu-group-vfio-next-20120529)

Please consider these for 3.5, but I'll settle for any kind of next
branch.  Thanks,

Alex

---

Alex Williamson (5):
      pci: Misc pci_reg additions
      pci: Create common pcibios_err_to_errno
      pci: export pci_user functions for use by other drivers
      pci: Add ACS validation utility
      pci: Add PCI DMA source ID quirk


 drivers/pci/access.c                 |    6 +-
 drivers/pci/pci.c                    |   68 ++++++++++++++++++++
 drivers/pci/pci.h                    |    7 --
 drivers/pci/quirks.c                 |   80 ++++++++++++++++++++++++
 drivers/xen/xen-pciback/conf_space.c |    6 +-
 include/linux/pci.h                  |   49 ++++++++++++++-
 include/linux/pci_regs.h             |  113 ++++++++++++++++++++++++++++++----
 7 files changed, 304 insertions(+), 25 deletions(-)
