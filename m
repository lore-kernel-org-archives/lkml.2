Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab2GXVKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2GXVKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:10:13 -0400
Message-ID: <500F0F27.5000407@redhat.com>
Date: Tue, 24 Jul 2012 17:09:59 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/32] provide interfaces to access PCIe capabilities
 registers
References: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1343147504-25891-1-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 12:31 PM, Jiang Liu wrote:
> From: Jiang Liu<liuj97@gmail.com>
>
> As suggested by Bjorn Helgaas and Don Dutile in threads
> http://www.spinics.net/lists/linux-pci/msg15663.html, we could improve access
> to PCIe capabilities register in to way:
> 1) cache content of PCIe Capabilities Register into struct pce_dev to avoid
>     repeatedly reading this register because it's read only.
> 2) provide access functions for PCIe Capabilities registers to hide differences
>     among PCIe base specifications, so the caller don't need to handle those
>     differences.
>
> This patch set applies to
> git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci-next
>
> And you could pull the change set from
> https://github.com/jiangliu/linux.git topic/pcie-cap
>
> These patch set is still RFC. It provides the new interfaces and has made the
> major changes to adopt those new interfaces. But there are still several device
> drivers left untouched. Any comments about the new interfaces are welcomed,
> especially about function names:). Once we reach an agreement, I will send out
> a formal version with all needed work done.
>
> v2: 1) change return value to 0 when the register is not implemented by
>         V1 PCIe devices.
>      2) Change all driver in the source tree to use the new interfaces.
>
> Jiang Liu (29):
>    PCI: add PCIe capabilities access functions to hide differences among
>      PCIe specs
>    PCI/core: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/hotplug: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/portdrv: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/pciehp: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/PME: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/AER: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/ASPM: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/ARM: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/MIPS: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/tile: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/r8169: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/broadcom: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/igb: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/vxge: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/mlx4: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/niu: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/myri10ge: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/chelsio: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/atl1c: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/ath9k: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/iwl: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/mthca: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/qib: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/qla: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/radeon: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/tsi721: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/et131x: use PCIe capabilities access functions to simplify
>      implementation
>    PCI/rtl8192e: use PCIe capabilities access functions to simplify
>      implementation
>
> Yijing Wang (3):
>    PCI: add pcie_flags_reg into struct pci_dev to cache PCIe
>      capabilities register
>    PCI: introduce pci_pcie_type(dev) to replace pci_dev->pcie_type
>    PCI: remove unused field pcie_type from struct pci_dev
>
>   arch/arm/mach-tegra/pcie.c                         |    7 +-
>   arch/mips/pci/pci-octeon.c                         |    7 +-
>   arch/powerpc/platforms/powernv/pci-ioda.c          |    2 +-
>   arch/tile/kernel/pci.c                             |   17 +-
>   drivers/gpu/drm/radeon/evergreen.c                 |    9 +-
>   drivers/infiniband/hw/mthca/mthca_reset.c          |    8 +-
>   drivers/infiniband/hw/qib/qib_pcie.c               |   40 ++-
>   drivers/iommu/intel-iommu.c                        |    6 +-
>   drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    2 +-
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   24 +-
>   drivers/net/ethernet/broadcom/tg3.c                |   46 ++--
>   drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |   19 +-
>   drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   10 +-
>   drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |    7 +-
>   drivers/net/ethernet/intel/e1000e/netdev.c         |   20 +-
>   drivers/net/ethernet/intel/igb/igb_main.c          |   12 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    2 +-
>   drivers/net/ethernet/mellanox/mlx4/reset.c         |    8 +-
>   drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   21 +-
>   drivers/net/ethernet/neterion/vxge/vxge-config.c   |    4 +-
>   .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +-
>   drivers/net/ethernet/realtek/r8169.c               |   35 +--
>   drivers/net/ethernet/sun/niu.c                     |    9 +-
>   drivers/net/wireless/ath/ath9k/pci.c               |   18 +-
>   drivers/net/wireless/iwlegacy/common.h             |    5 +-
>   drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |    4 +-
>   drivers/net/wireless/rtlwifi/pci.c                 |    8 +-
>   drivers/pci/access.c                               |  157 ++++++++++++
>   drivers/pci/hotplug/pciehp_acpi.c                  |    6 +-
>   drivers/pci/hotplug/pciehp_hpc.c                   |   10 +-
>   drivers/pci/hotplug/pcihp_slot.c                   |   12 +-
>   drivers/pci/iov.c                                  |    6 +-
>   drivers/pci/pci.c                                  |  262 +++++---------------
>   drivers/pci/pcie/aer/aer_inject.c                  |    2 +-
>   drivers/pci/pcie/aer/aerdrv.c                      |   23 +-
>   drivers/pci/pcie/aer/aerdrv_acpi.c                 |    2 +-
>   drivers/pci/pcie/aer/aerdrv_core.c                 |   27 +-
>   drivers/pci/pcie/aspm.c                            |  108 ++++----
>   drivers/pci/pcie/pme.c                             |   23 +-
>   drivers/pci/pcie/portdrv_bus.c                     |    2 +-
>   drivers/pci/pcie/portdrv_core.c                    |   24 +-
>   drivers/pci/pcie/portdrv_pci.c                     |   15 +-
>   drivers/pci/probe.c                                |   29 +--
>   drivers/pci/quirks.c                               |    9 +-
>   drivers/pci/search.c                               |    2 +-
>   drivers/rapidio/devices/tsi721.c                   |   13 +-
>   drivers/scsi/qla2xxx/qla_init.c                    |    4 +-
>   drivers/scsi/qla2xxx/qla_nx.c                      |    8 +-
>   drivers/scsi/qla4xxx/ql4_nx.c                      |    4 +-
>   drivers/staging/et131x/et131x.c                    |    9 +-
>   drivers/staging/rtl8192e/rtl8192e/rtl_pci.c        |    8 +-
>   include/linux/pci.h                                |   17 +-
>   include/linux/pci_regs.h                           |    2 +
>   53 files changed, 510 insertions(+), 626 deletions(-)
>

Summary:
I commented on 01, 04 & 05/32;
Overall, excellent cleanup, esp. in all the various drivers,
since driver replication is common, and that'll help correct future
drivers (wishful thinking, I know...).

Note that the comment of eliminating pci_is_pcie() and incorporating
it into the pci_pcie_capability_[read,write]_[byte,word,dword]() functions
could be applied to other patches as well (06, 10 ... and that I stopped looking
due to time constraints & repetitiveness... since this is RFC, not final patch post).


