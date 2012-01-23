Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2AWRVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:21:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2AWRVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:21:16 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 0/5] VFIO core framework
To: chrisw@sous-sol.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, agraf@suse.de, benve@cisco.com,
        aafabbri@cisco.com, B08248@freescale.com, B07421@freescale.com,
        avi@redhat.com, konrad.wilk@oracle.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2012 10:20:05 -0700
Message-ID: <20120123165620.26865.51875.stgit@bling.home>
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

This series can also be found here:

git://github.com/awilliam/linux-vfio.git vfio-next

This plus the PCI VFIO bus driver for exposing PCI devices to
userspace can be found here:

git://github.com/awilliam/linux-vfio.git vfio-next-staging

or here for a linux-2.6.git based tree:

git://github.com/awilliam/linux-vfio.git vfio-linux-staging

A fully functional qemu driver for doing non-KVM based PCI
device assignment can be found here:

git://github.com/awilliam/qemu-vfio.git vfio-ng

I'd like to propose VFIO for inclusion in Linux 3.4, starting with
this core framework series.  Once we have agreement on these, I'll
split up and post the VFIO PCI bus driver for inclusion as well.
I can also host the above vfio-next branch for inclusion in
linux-next.  Please review and comment.  Thanks,

Alex

v2: Interrupt setup ioctl rework based on comments by Konrad.
    The interrupt ioctls are no longer exclusively targeted
    at eventfds, allowing for more flexibility of other vfio
    bus drivers making use of alternate mechanisms.  Also
    updated vfio_iommu_info to report common IOMMU geometry
    fields that we know we're going to need for Freescale
    PAMU.  Additional ioctls and fields to be added via flags
    as they're implemented in the IOMMU API.

---

Alex Williamson (5):
      vfio: VFIO core Kconfig and Makefile
      vfio: VFIO core IOMMU mapping support
      vfio: VFIO core group interface
      vfio: VFIO core header
      vfio: Introduce documentation for VFIO driver


 Documentation/ioctl/ioctl-number.txt |    1 
 Documentation/vfio.txt               |  359 ++++++++++
 MAINTAINERS                          |    8 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/vfio/Kconfig                 |    8 
 drivers/vfio/Makefile                |    3 
 drivers/vfio/vfio_iommu.c            |  611 +++++++++++++++++
 drivers/vfio/vfio_main.c             | 1248 ++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_private.h          |   36 +
 include/linux/vfio.h                 |  395 +++++++++++
 11 files changed, 2672 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/vfio.txt
 create mode 100644 drivers/vfio/Kconfig
 create mode 100644 drivers/vfio/Makefile
 create mode 100644 drivers/vfio/vfio_iommu.c
 create mode 100644 drivers/vfio/vfio_main.c
 create mode 100644 drivers/vfio/vfio_private.h
 create mode 100644 include/linux/vfio.h
