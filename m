Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2GZQPU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 12:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2GZQPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 12:15:18 -0400
Message-ID: <1343319288.3125.24.camel@ul30vt>
Subject: [GIT PULL (PATCH 0/4) v2] VFIO driver for v3.6
From: Alex Williamson <alex.williamson@redhat.com>
To: torvalds@linux-foundation.org
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        gregkh@linuxfoundation.org, joerg.roedel@amd.com, dwmw2@infradead.org,
        chrisw@sous-sol.org, agraf@suse.de, benve@cisco.com,
        aafabbri@cisco.com, B08248@freescale.com, B07421@freescale.com,
        avi@redhat.com, konrad.wilk@oracle.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, ddutile@redhat.com
Date: Thu, 26 Jul 2012 10:14:48 -0600
In-Reply-To: <20120725142254.12800.61860.stgit@bling.home>
References: <20120725142254.12800.61860.stgit@bling.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 08:53 -0600, Alex Williamson wrote:
> Hi Linus,
> 
> This series includes the VFIO userspace driver interface for the
> 3.6 kernel merge window.  This driver is intended to provide a
> secure interface for device access using IOMMU protection for
> applications like assignment of physical devices to virtual
> machines.  Qemu will be the first user of this interface, enabling
> assignment of PCI devices to Qemu guests.  This interface is
> intended to eventually replace the x86-specific assignment mechanism
> currently available in KVM.  This interface has the advantage of
> being more secure, by working with IOMMU groups to ensure device
> isolation and providing it's own filtered resource access mechanism,
> and also more flexible, in not being x86 or KVM specific (extensions
> to enable POWER are already working).
> 
> As a new driver, I'm including both the individual patches in email,
> as well as a branch to pull from:
> 
> git://github.com/awilliam/linux-vfio.git for-linus
> 
> This driver is originally the work of Tom Lyon, but has since been
> handed over to me and gone through a complete overhaul thanks to the
> input from David Gibson, Ben Herrenschmidt, Chris Wright, Joerg
> Roedel, and others.  This driver has been available in linux-next for
> the last month.  Thanks,

randconfig testing in next found a dependency issue that I've fix in the
for-linus branch above.  Change from v1 is:

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index cc7db62..5980758 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,6 +1,6 @@
 config VFIO_PCI
 	tristate "VFIO support for PCI devices"
-	depends on VFIO && PCI
+	depends on VFIO && PCI && EVENTFD
 	help
 	  Support for the PCI VFIO bus driver.  This is required to make
 	  use of PCI drivers using the VFIO framework.

If anyone wants a full resend of v2 to the list with this change, please
let me know.  Thanks,

Alex

> ---
> 
> Alex Williamson (4):
>       vfio: Add PCI device driver
>       vfio: Type1 IOMMU implementation
>       vfio: Add documentation
>       vfio: VFIO core
> 
> 
>  Documentation/ioctl/ioctl-number.txt |    1 
>  Documentation/vfio.txt               |  314 +++++++
>  MAINTAINERS                          |    8 
>  drivers/Kconfig                      |    2 
>  drivers/Makefile                     |    1 
>  drivers/vfio/Kconfig                 |   16 
>  drivers/vfio/Makefile                |    3 
>  drivers/vfio/pci/Kconfig             |    8 
>  drivers/vfio/pci/Makefile            |    4 
>  drivers/vfio/pci/vfio_pci.c          |  579 +++++++++++++
>  drivers/vfio/pci/vfio_pci_config.c   | 1540 ++++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_intrs.c    |  740 ++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h  |   91 ++
>  drivers/vfio/pci/vfio_pci_rdwr.c     |  269 ++++++
>  drivers/vfio/vfio.c                  | 1420 +++++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_type1.c      |  753 +++++++++++++++++
>  include/linux/vfio.h                 |  445 ++++++++++
>  17 files changed, 6194 insertions(+)
>  create mode 100644 Documentation/vfio.txt
>  create mode 100644 drivers/vfio/Kconfig
>  create mode 100644 drivers/vfio/Makefile
>  create mode 100644 drivers/vfio/pci/Kconfig
>  create mode 100644 drivers/vfio/pci/Makefile
>  create mode 100644 drivers/vfio/pci/vfio_pci.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_config.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_intrs.c
>  create mode 100644 drivers/vfio/pci/vfio_pci_private.h
>  create mode 100644 drivers/vfio/pci/vfio_pci_rdwr.c
>  create mode 100644 drivers/vfio/vfio.c
>  create mode 100644 drivers/vfio/vfio_iommu_type1.c
>  create mode 100644 include/linux/vfio.h



