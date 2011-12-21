Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1LUVmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:42:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1LUVmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:42:22 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/5] VFIO core framework
To: chrisw@sous-sol.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, agraf@suse.de, benve@cisco.com,
        aafabbri@cisco.com, B08248@freescale.com, B07421@freescale.com,
        avi@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Dec 2011 14:42:02 -0700
Message-ID: <20111221213019.27028.26890.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series includes the core framework for the VFIO driver.
VFIO is a userspace driver interface meant to replace both the
KVM device assignment code as well as interfaces like UIO.  Please
see patch 1/5 for a complete description of VFIO, what it can do,
and how it's designed.

This version and the VFIO PCI bus driver, for exposing PCI devices
through VFIO, can be found here:

git://github.com/awilliam/linux-vfio.git vfio-next-20111221

A development version of qemu which includes a full working
vfio-pci driver, indepdendent of KVM support, can be found here:

git://github.com/awilliam/qemu-vfio.git vfio-ng

Thanks,

Alex

PS - I'll be mostly unavailable over the holidays, but wanted to get
this out for review and comparison to the isolation APIs being proposed.

---

Alex Williamson (5):
      vfio: VFIO core Kconfig and Makefile
      vfio: VFIO core IOMMU mapping support
      vfio: VFIO core group interface
      vfio: VFIO core header
      vfio: Introduce documentation for VFIO driver


 Documentation/ioctl/ioctl-number.txt |    1 
 Documentation/vfio.txt               |  352 ++++++++++
 MAINTAINERS                          |    8 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/vfio/Kconfig                 |    8 
 drivers/vfio/Makefile                |    3 
 drivers/vfio/vfio_iommu.c            |  593 +++++++++++++++++
 drivers/vfio/vfio_main.c             | 1201 ++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_private.h          |   36 +
 include/linux/vfio.h                 |  353 ++++++++++
 11 files changed, 2558 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/vfio.txt
 create mode 100644 drivers/vfio/Kconfig
 create mode 100644 drivers/vfio/Makefile
 create mode 100644 drivers/vfio/vfio_iommu.c
 create mode 100644 drivers/vfio/vfio_main.c
 create mode 100644 drivers/vfio/vfio_private.h
 create mode 100644 include/linux/vfio.h
