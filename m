Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862Ab2CMH05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:26:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27710 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759367Ab2CMH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:26:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/12] PCI, x86: More pci hotplug related cleanup
Date: Tue, 13 Mar 2012 00:26:22 -0700
Message-Id: <1331623594-30543-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F5EF6B9.0094,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will claim hw/fw allocated resource.
also add addon_resource support, and make cpc_hotplug/shpchp configure
devices more like pciehp.

The patches need to apply to pci/for-linus and pci/linux-next
and [PATCH 00/36] PCI: pci_host_bridge related cleanup and busn_alloc
and [PATCH v2 00/37] PCI, x86: pci root bus hotplug support

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-hotplug-more

Thanks

Yinghai

Yinghai Lu (12):
  PCI: Add debug print out for pci related dev release
  x86, PCI: Let pcibios_allocate_bus_resources() take bus instead
  PCI: Claim hw/fw allocated resources in hot add path.
  PCI: Kill pci_is_reassignedev()
  PCI: Add addon_resource support for pci_dev
  PCI: Use for_each_pci_dev_resource helper
  PCI: Make piix4 quirk to use addon_resource support
  PCI: Make quirk_io_region to use addon_resource support
  PCI: Use addon_fixed_resource with ati fixed resource
  PCI, pciehp: Separate pci_hp_add_bridge()
  PCI, cphi_hotplug: Simplify configure_slot
  PCI, shpchp: Simplify configure_device

 arch/x86/pci/common.c                  |    3 +-
 arch/x86/pci/i386.c                    |  164 +++++++++++---------
 arch/x86/pci/mrst.c                    |    7 +-
 drivers/pci/bus.c                      |    2 +
 drivers/pci/hotplug-pci.c              |   13 ++
 drivers/pci/hotplug/acpiphp_glue.c     |    4 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |   35 +----
 drivers/pci/hotplug/pciehp_hpc.c       |    5 +-
 drivers/pci/hotplug/pciehp_pci.c       |   18 +--
 drivers/pci/hotplug/shpchp_pci.c       |   45 ++----
 drivers/pci/iov.c                      |   31 ++--
 drivers/pci/pci-driver.c               |    6 +-
 drivers/pci/pci.c                      |   45 +++---
 drivers/pci/pci.h                      |    1 +
 drivers/pci/probe.c                    |  117 ++++++++++++++-
 drivers/pci/quirks.c                   |  256 +++++++++++++++++++-------------
 drivers/pci/remove.c                   |    5 +-
 drivers/pci/setup-bus.c                |   32 ++--
 drivers/pci/setup-res.c                |   38 +++--
 drivers/pci/xen-pcifront.c             |    4 +-
 include/linux/pci.h                    |   78 +++++++++-
 21 files changed, 564 insertions(+), 345 deletions(-)

-- 
1.7.7

