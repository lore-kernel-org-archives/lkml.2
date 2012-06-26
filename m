Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2FZE4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:56:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab2FZE4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:56:18 -0400
Message-ID: <1340686552.1207.128.camel@bling.home>
Subject: Request VFIO inclusion in linux-next
From: Alex Williamson <alex.williamson@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        chrisw <chrisw@sous-sol.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        linux-next@vger.kernel.org
Date: Mon, 25 Jun 2012 22:55:52 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

VFIO has been kicking around for well over a year now and has been
posted numerous times for review.  The pre-requirements are finally
available in linux-next (or will be in the 20120626 build) so I'd like
to request a new branch be included in linux-next with a goal of being
accepted into v3.6.

VFIO is a userspace driver interface designed to support assignment of
devices into virtual machines using IOMMU level access control.  This
IOMMU requirement, secure resource access, and flexible interrupt
support make VFIO unique from existing drivers, like UIO.  VFIO supports
modular backends for both IOMMU and device access.  Initial backends are
included for PCI device assignment using the IOMMU API in a manner
compatible with x86 device assignment.  POWER support is also under
development, making use of the same PCI device backend, but adding new
IOMMU support for their platforms.

As with previous versions of VFIO, Qemu is targeted as a primary user
and a working development tree including vfio-pci support can be found
here:

git://github.com/awilliam/qemu-vfio.git iommu-group-vfio

Eventually we hope VFIO can deprecate the x86, PCI-specific device
assignment currently used by KVM.

The info for linux-next:

Tree: git://github.com/awilliam/linux-vfio.git
Branch: next
Contact: Alex Williamson <alex.williamson@redhat.com>

This branch should be applied after both Bjorn's PCI next branch and
Joerg's IOMMU next branch and contains the following changes:

 Documentation/ioctl/ioctl-number.txt |    1 
 Documentation/vfio.txt               |  315 +++++++
 MAINTAINERS                          |    8 
 drivers/Kconfig                      |    2 
 drivers/Makefile                     |    1 
 drivers/vfio/Kconfig                 |   16 
 drivers/vfio/Makefile                |    3 
 drivers/vfio/pci/Kconfig             |    8 
 drivers/vfio/pci/Makefile            |    4 
 drivers/vfio/pci/vfio_pci.c          |  565 ++++++++++++
 drivers/vfio/pci/vfio_pci_config.c   | 1528 +++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_intrs.c    |  727 ++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h  |   91 ++
 drivers/vfio/pci/vfio_pci_rdwr.c     |  269 ++++++
 drivers/vfio/vfio.c                  | 1420 ++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c      |  754 +++++++++++++++++
 include/linux/vfio.h                 |  445 ++++++++++
 17 files changed, 6157 insertions(+)

If there are any objections to including this, please speak now.  If
anything looks amiss in the branch, let me know.  I've never hosted a
next branch.  Review comments welcome and I'll be glad to post the
series in email again if requested.  Thanks,

Alex

