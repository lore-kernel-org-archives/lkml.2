Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2E3Fed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 01:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab2E3Fec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 01:34:32 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/4] VFIO
To: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        gregkh@linuxfoundation.org
Cc: joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com, ddutile@redhat.com,
        alex.williamson@redhat.com
Date: Tue, 29 May 2012 23:34:05 -0600
Message-ID: <20120530051317.1934.28218.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements the core VFIO infrastructure, documentation,
an IOMMU backend suitable for x86 usage, and a PCI device driver.
These patches are based on the previous v2 IOMMU Groups + VFIO
patches and are dependent on the previously sent out PCI and IOMMU
groups series found here:

http://marc.info/?l=linux-kernel&m=133835363021384
http://marc.info/?l=linux-kernel&m=133835480021716

As noted in previous postings and the included documentation, VFIO
provides secure, IOMMU protected, userspace access to I/O devices
for use by things like PCI device assignment to virtual machines
in Qemu.  This driver is meant to replace existing KVM device
assignment and hopefully take over much of what UIO does today.

I'm looking for suggestions not only on the code, but on the best
way to get this upstream.  If we can get some initial blessing for
this driver I'd be happy to host a next branch for it or submit it
as a staging driver.  I think Bjorn and Joerg would probably
appreciate and kind of nod that this driver has legs in order to
include the PCI and IOMMU backend support.  Alexey Kardashevskiy
has already posted an initial draft of POWER support for VFIO
giving some validation as a cross architecture solution.

These patches, as well as the PCI support patches and IOMMU group
infrastructure can be found in git here:

git://github.com/awilliam/linux-vfio.git (iommu-group-vfio-next-20120529)

A qemu tree including a vfio-pci driver capable of assigning PCI
devices to Qemu guests can be found here:

git://github.com/awilliam/qemu-vfio.git (iommu-group-vfio)

Thanks, 
Alex

---

Alex Williamson (4):
      vfio: Add PCI device driver
      vfio: Type1 IOMMU implementation
      vfio: Add documentation
      vfio: VFIO core


 Documentation/ioctl/ioctl-number.txt |    1 
 Documentation/vfio.txt               |  315 +++++++
 MAINTAINERS                          |    8 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/vfio/Kconfig                 |   16 
 drivers/vfio/Makefile                |    3 
 drivers/vfio/pci/Kconfig             |    8 
 drivers/vfio/pci/Makefile            |    4 
 drivers/vfio/pci/vfio_pci.c          |  559 ++++++++++++
 drivers/vfio/pci/vfio_pci_config.c   | 1528 ++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c    |  725 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h  |   91 ++
 drivers/vfio/pci/vfio_pci_rdwr.c     |  269 ++++++
 drivers/vfio/vfio.c                  | 1422 ++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c      |  754 +++++++++++++++++
 include/linux/vfio.h                 |  445 ++++++++++
 17 files changed, 6151 insertions(+)
 create mode 100644 Documentation/vfio.txt
 create mode 100644 drivers/vfio/Kconfig
 create mode 100644 drivers/vfio/Makefile
 create mode 100644 drivers/vfio/pci/Kconfig
 create mode 100644 drivers/vfio/pci/Makefile
 create mode 100644 drivers/vfio/pci/vfio_pci.c
 create mode 100644 drivers/vfio/pci/vfio_pci_config.c
 create mode 100644 drivers/vfio/pci/vfio_pci_intrs.c
 create mode 100644 drivers/vfio/pci/vfio_pci_private.h
 create mode 100644 drivers/vfio/pci/vfio_pci_rdwr.c
 create mode 100644 drivers/vfio/vfio.c
 create mode 100644 drivers/vfio/vfio_iommu_type1.c
 create mode 100644 include/linux/vfio.h
