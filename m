Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150Ab2EXV4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab2EXV4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:56:36 -0400
Message-ID: <4FBEAE70.8090908@redhat.com>
Date: Thu, 24 May 2012 17:56:00 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        bhelgaas@google.com
Subject: Re: [PATCH v2 00/13] IOMMU Groups + VFIO
References: <20120522043607.5871.11340.stgit@bling.home>
In-Reply-To: <20120522043607.5871.11340.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 01:04 AM, Alex Williamson wrote:
> Version 2 incorporating acks and feedback from v1.  The PCI DMA quirk
> and ACS check are reworked, sysfs iommu groups ABI Documentation
> added as well as numerous other fixes, including patches from Alexey
> Kardashevskiy towards supporting POWER usage of VFIO and IOMMU groups.
>
> This series can be found here on top of 3.4:
>
> git://github.com/awilliam/linux-vfio.git iommu-group-vfio-20120521
>
> The Qemu tree has also been updated to Qemu 1.1 and can be found here:
>
> git://github.com/awilliam/qemu-vfio.git iommu-group-vfio
>
> I'd really like to make a push to get this in for 3.5, so let's talk
> about how to do that across iommu, pci, and new driver.  Joerg, are
> you sufficiently happy with the IOMMU group concept and code?  We'll
> also need David Woodhouse buyin on the intel-iommu changes in patches
> 3&  6.  Who needs to approve VFIO as a new driver, GregKH?  Bjorn,
> I'd be happy to send the PCI changes as a series for you, but I
> wonder if it makes sense to collect acks for them if you approve and
> bundle them in with the associated code that needs them so you're
> not left with unused code.  Let me know which you prefer.  If there
> are better ways to do it, please let me know.  Thanks,
>
> Alex
>
> ---
ack to 1,2,4,6,8,10 & 11.
provided some minor feedback on 3,9,&12.
have to do final review of the big stuff, 7 & 13.
>
> Alex Williamson (13):
>        vfio: Add PCI device driver
>        pci: Misc pci_reg additions
>        pci: Create common pcibios_err_to_errno
>        pci: export pci_user functions for use by other drivers
>        vfio: x86 IOMMU implementation
>        vfio: Add documentation
>        vfio: VFIO core
>        iommu: Make use of DMA quirking and ACS enabled check for groups
>        pci: Add ACS validation utility
>        pci: Add PCI DMA source ID quirk
>        iommu: IOMMU groups for VT-d and AMD-Vi
>        iommu: IOMMU Groups
>        driver core: Add iommu_group tracking to struct device
>
>
>   .../ABI/testing/sysfs-kernel-iommu_groups          |   14
>   Documentation/ioctl/ioctl-number.txt               |    1
>   Documentation/vfio.txt                             |  315 ++++
>   MAINTAINERS                                        |    8
>   drivers/Kconfig                                    |    2
>   drivers/Makefile                                   |    1
>   drivers/iommu/amd_iommu.c                          |   67 +
>   drivers/iommu/intel-iommu.c                        |   87 +
>   drivers/iommu/iommu.c                              |  578 +++++++-
>   drivers/pci/access.c                               |    6
>   drivers/pci/pci.c                                  |   76 +
>   drivers/pci/pci.h                                  |    7
>   drivers/pci/quirks.c                               |   69 +
>   drivers/vfio/Kconfig                               |   16
>   drivers/vfio/Makefile                              |    3
>   drivers/vfio/pci/Kconfig                           |    8
>   drivers/vfio/pci/Makefile                          |    4
>   drivers/vfio/pci/vfio_pci.c                        |  557 +++++++
>   drivers/vfio/pci/vfio_pci_config.c                 | 1522 ++++++++++++++++++++
>   drivers/vfio/pci/vfio_pci_intrs.c                  |  724 ++++++++++
>   drivers/vfio/pci/vfio_pci_private.h                |   91 +
>   drivers/vfio/pci/vfio_pci_rdwr.c                   |  269 ++++
>   drivers/vfio/vfio.c                                | 1413 +++++++++++++++++++
>   drivers/vfio/vfio_iommu_x86.c                      |  743 ++++++++++
>   drivers/xen/xen-pciback/conf_space.c               |    6
>   include/linux/device.h                             |    2
>   include/linux/iommu.h                              |  104 +
>   include/linux/pci.h                                |   49 +
>   include/linux/pci_regs.h                           |  112 +
>   include/linux/vfio.h                               |  444 ++++++
>   30 files changed, 7182 insertions(+), 116 deletions(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-kernel-iommu_groups
>   create mode 100644 Documentation/vfio.txt
>   create mode 100644 drivers/vfio/Kconfig
>   create mode 100644 drivers/vfio/Makefile
>   create mode 100644 drivers/vfio/pci/Kconfig
>   create mode 100644 drivers/vfio/pci/Makefile
>   create mode 100644 drivers/vfio/pci/vfio_pci.c
>   create mode 100644 drivers/vfio/pci/vfio_pci_config.c
>   create mode 100644 drivers/vfio/pci/vfio_pci_intrs.c
>   create mode 100644 drivers/vfio/pci/vfio_pci_private.h
>   create mode 100644 drivers/vfio/pci/vfio_pci_rdwr.c
>   create mode 100644 drivers/vfio/vfio.c
>   create mode 100644 drivers/vfio/vfio_iommu_x86.c
>   create mode 100644 include/linux/vfio.h

