Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2JQHwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 03:52:02 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12085 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2JQHv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 03:51:58 -0400
Message-ID: <507E6355.40904@huawei.com>
Date: Wed, 17 Oct 2012 15:50:45 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 00/40] PCI, ACPI, x86: pci root bus hotplug support
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com> <1348080894-23412-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.84]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/9/20 2:54, Yinghai Lu wrote:

Hi Yinghai,
   I applied this series patches to the latest pci-next, but git am fail occured.
When I try to pull from for-pci-root-bus-hotplug branch, I found some patches missed(eg. SCI_EMULATE).
Where can I get the newest pci root bus hotplug patches?

Thanks!
Yijing

> It supports pci root bus removal with
> 	echo "PCI0 3" > /sys/kernel/debug/acpi/sci_notify
> 
> add with
> 	echo "PCI0 0" > /sys/kernel/debug/acpi/sci_notify
> 
> based on pci/next
> 
> We need to separate pci root bus add from acpiphp. so user could only root bus
> hotplug and pciehp that will make system fw simple.
> Also later CONFIG_HOTPLUG will be removed, so pci root bus hotplug will be
> enabled by default and user still need select acpiphp and pciehp for normal
> pci device hotplug support.
> 
> could get from
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug
> 
> -v6: do not depend on busn-alloc anymore.
> 
> part1: cleanup for pci/next
> [PATCH 01/40] PCI: fix default vga ref_count
> [PATCH 02/40] PCI, x86: clear initial value for root info resources
> [PATCH 03/40] PCI, ia64: clear initial value for root info resources
> [PATCH 04/40] PCI, acpiphp: Add is_hotplug_bridge detection
> [PATCH 05/40] PCI: Add root bus children dev's res to fail list
> [PATCH 06/40] PCI: Split out stop_bus_device and remove_bus_dev
> 
> part2: reserve BIOS allocated resource for hotadd root bus
> [PATCH 07/40] x86, PCI: Separate pcibios_allocate_bridge_resources()
> [PATCH 08/40] x86, PCI: Separate pcibios_allocate_dev_resources()
> [PATCH 09/40] x86, PCI: Let pcibios_allocate_bus_resources() take us instead
> [PATCH 10/40] x86, PCI: Separate rom resource claim out
> [PATCH 11/40] PCI, x86: Add pcibios_fw_addr_done
> [PATCH 12/40] PCI, x86: Remove __init for hw/fw allocated functions
> [PATCH 13/40] PCI: Claim hw/fw allocated resources in hot add path.
> 
> part3: pci_assign_unsissigned_bus_resources() for root bus add.
> [PATCH 14/40] PCI: Separate out pci_assign_unassigned_bus_resources()
> [PATCH 15/40] PCI: Move back pci_rescan_bus() to probe.c
> [PATCH 16/40] PCI: pci_bus_size_bridges() should not size own bridge
> [PATCH 17/40] PCI: Use __pci_bus_size_bridges() directly in pci_assign_unassigned_bus_resources()
> [PATCH 18/40] PCI: Rescan bus using callback method too
> [PATCH 19/40] PCI, sysfs: Clean up rescan/remove with schedule_callback
> 
> part4: Separate root bus add from acpiphp and add removal support.
> [PATCH 20/40] PCI: Fix a device reference count leakage issue in
> [PATCH 21/40] PCI: Add pci_stop_and_remove_root_bus()
> [PATCH 22/40] PCI, acpiphp: Separate out hot-add support of pci host
> [PATCH 23/40] PCI, ACPI: Pass device instead of handle when config
> [PATCH 24/40] PCI, acpi: Update acpi_pci_driver add/remove interface
> [PATCH 25/40] PCI, ACPI: Make acpi_pci_root_remove remove pci root
> [PATCH 26/40] PCI, ACPI: del root bus prt
> [PATCH 27/40] ACPI: acpi_bus_trim to support two steps.
> [PATCH 28/40] PCI, ACPI: Add pci_root_hp hot removal notification
> [PATCH 29/40] PCI, ACPI: Add alloc_acpi_hp_work()
> [PATCH 30/40] PCI, acpiphp: Use acpi_hp_work
> [PATCH 31/40] PCI, pci_root_hp: Use acpi_hp_work
> [PATCH 32/40] PCI, ACPI: Make kacpi_hotplug_wq static
> 
> part5: add/remove calling for acpi_pci_drivers.
> [PATCH 33/40] ACPI, PCI: Use normal list for struct acpi_pci_driver
> [PATCH 34/40] ACPI, PCI: Notify acpi_pci_drivers when hot-plugging
> [PATCH 35/40] ACPI, PCI: Protect global lists in
> [PATCH 36/40] PCI: Set dev_node early for pci_dev
> [PATCH 37/40] PCI, x86: Move pci_enable_bridges() down
> [PATCH 38/40] ACPI, PCI: Skip extra pci_enable_bridges for non
> [PATCH 39/40] PCI, acpiphp: Don't ailout even no slots found yet.
> 
> part6: acpi add/remove simulation
> [PATCH 40/40] ACPI: Enable SCI_EMULATE to manually simulate physical
> 
>  arch/ia64/pci/pci.c                |    3 +-
>  arch/x86/pci/acpi.c                |    3 +-
>  arch/x86/pci/i386.c                |  185 ++++++++++++++++--------
>  drivers/acpi/Kconfig               |   10 ++
>  drivers/acpi/Makefile              |    2 +
>  drivers/acpi/osl.c                 |   24 +++-
>  drivers/acpi/pci_root.c            |  123 ++++++++++------
>  drivers/acpi/pci_root_hp.c         |  278 ++++++++++++++++++++++++++++++++++++
>  drivers/acpi/pci_slot.c            |   12 +-
>  drivers/acpi/scan.c                |    5 +-
>  drivers/acpi/sci_emu.c             |  145 +++++++++++++++++++
>  drivers/gpu/vga/vgaarb.c           |   14 ++-
>  drivers/pci/bus.c                  |    2 +
>  drivers/pci/hotplug/acpiphp.h      |    1 -
>  drivers/pci/hotplug/acpiphp_core.c |   23 +---
>  drivers/pci/hotplug/acpiphp_glue.c |  165 +++++++--------------
>  drivers/pci/pci-sysfs.c            |   41 ++++--
>  drivers/pci/probe.c                |   26 ++++-
>  drivers/pci/remove.c               |   87 +++++++++--
>  drivers/pci/search.c               |   10 +-
>  drivers/pci/setup-bus.c            |   54 +++-----
>  include/acpi/acpi_bus.h            |    1 +
>  include/acpi/acpiosxf.h            |    9 +-
>  include/linux/acpi.h               |    6 +-
>  include/linux/pci.h                |    5 +
>  25 files changed, 899 insertions(+), 335 deletions(-)
>  create mode 100644 drivers/acpi/pci_root_hp.c
>  create mode 100644 drivers/acpi/sci_emu.c
> 


-- 
Thanks!
Yijing

