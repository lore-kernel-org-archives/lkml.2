Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab0EUVum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 17:50:42 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:41014 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755483Ab0EUVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 17:50:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mmoHWeThZbsYRddYRkRV4H2kAXZLQKTmvQW0q1znmNTemEOjFAXMnp8twkb1lbw2otPPjraE6uPcREwb1p31rYqBy0Dub17YKc05aQf3GzqwIYLafy0Z/riwVJ2GmFQ1;
Date: Fri, 21 May 2010 14:48:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20100521144859.0a5b18c9@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
fc2a093e7ad23e935aa29e349bc27173c92f1a95: Linus Torvalds (1):
        Merge branch 'drm-linus' of
git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 ..BRANCH.NOT.VERIFIED..

Sorry about the "not verified" bit, I just rebased the top 3 patches &
pushed an update to drop one Bjorn was a little nervous about.  The rest
have been soaking for some time.

There's nothing too exciting in here compared to last time, it's a
small set of changes, but there are a few good bits: Alan's basic
resource exclusion mechanism, a few good quirks for various chipsets and
machines, and other misc. fixes and improvements.

Thanks,
Jesse

Alan Cox (1):
      resource: shared I/O region support

Alan Stern (1):
      PCI: clearing wakeup flags not needed

Alex Chiang (1):
      PCI: create function symlinks in /sys/bus/pci/slots/N/

Alex Deucher (1):
      PCI quirks: disable msi on AMD rs4xx internal gfx bridges

Ben Hutchings (1):
      PCI: Disable MSI for MCP55 on P5N32-E SLI

Felix Radensky (1):
      PCI: Allow manual resource allocation for PCI hotplug bridges

Feng Tang (1):
      x86/PCI: make ACPI MCFG reserved error messages ACPI specific

Hidetoshi Seto (18):
      PCI: aerdrv, doc: update example output in pcieaer-howto.txt
      PCI: aerdrv: RsvdP of PCI_ERR_ROOT_COMMAND
      PCI: aerdrv: cleanup inconsistent functions
      PCI: aerdrv: make aer_{en,dis}able_rootport static
      PCI: aerdrv: rework find_source_device
      PCI: aerdrv: introduce is_error_source
      PCI: aerdrv: remove compare_device_id
      PCI: aerdrv: rework add_error_device
      PCI: aerdrv: rework aer_isr_one_error()
      PCI: aerdrv: rework get_e_source()
      PCI: aerdrv: rework do_recovery
      PCI: aerdrv: redefine PCI_ERR_ROOT_*_SRC
      PCI: aerdrv: remove magical ROOT_ERR_STATUS_MASKS
      PCI: aerdrv: remove is_downstream
      PCI: aerdrv: rework find_aer_service
      PCI: aerdrv: introduce default_downstream_reset_link
      PCI: aerdrv: trivial cleanup for aerdrv.c
      PCI: aerdrv: trivial cleanup for aerdrv_core.c

Ira W. Snyder (1):
      PCI: read memory ranges out of Broadcom CNB20LE host bridge

Jesse Barnes (1):
      PCI: change PCI_MSI help text to recommend enabling

Julia Lawall (1):
      PCI hotplug: Use kmemdup

Michal Schmidt (1):
      PCI: return correct value when writing to the "reset" attribute

Prarit Bhargava (1):
      PCI: output FW warning in pci_read/write_vpd

Praveen Kalamegham (1):
      PCI: hotplug: pciehp: Removed check for hotplug of display devices

Rafael J. Wysocki (1):
      PM/PCI: Update PCI power management documentation

Roman Fietze (1):
      PCI: fix typos pci_device_dis/enable to pci_dis/enable_device in comments

Seth Heasley (1):
      x86/PCI: irq and pci_ids patch for additional Intel Cougar Point DeviceIDs

Thomas Gleixner (2):
      PCI: Convert pci_lock to raw_spinlock
      x86/PCI: Convert pci_config_lock to raw_spinlock

 Documentation/ABI/testing/sysfs-bus-pci |   40 +
 Documentation/PCI/pcieaer-howto.txt     |   29 +-
 Documentation/power/pci.txt             | 1258 ++++++++++++++++++++++++-------
 arch/x86/Kconfig                        |    8 +
 arch/x86/include/asm/pci_x86.h          |    2 +-
 arch/x86/pci/Makefile                   |    2 +
 arch/x86/pci/broadcom_bus.c             |  101 +++
 arch/x86/pci/common.c                   |    2 +-
 arch/x86/pci/direct.c                   |   16 +-
 arch/x86/pci/irq.c                      |    9 +-
 arch/x86/pci/mmconfig-shared.c          |   17 +-
 arch/x86/pci/mmconfig_32.c              |    8 +-
 arch/x86/pci/numaq_32.c                 |    8 +-
 arch/x86/pci/pcbios.c                   |    8 +-
 drivers/edac/amd76x_edac.c              |    2 +-
 drivers/edac/i82443bxgx_edac.c          |    2 +-
 drivers/edac/r82600_edac.c              |    2 +-
 drivers/pci/Kconfig                     |    2 +-
 drivers/pci/access.c                    |   41 +-
 drivers/pci/hotplug/cpqphp_core.c       |    3 +-
 drivers/pci/hotplug/pciehp_pci.c        |   17 +-
 drivers/pci/pci-sysfs.c                 |   44 ++-
 drivers/pci/pci.c                       |    4 +-
 drivers/pci/pcie/aer/aer_inject.c       |    2 +-
 drivers/pci/pcie/aer/aerdrv.c           |  179 ++++--
 drivers/pci/pcie/aer/aerdrv.h           |    6 +-
 drivers/pci/pcie/aer/aerdrv_core.c      |  558 ++++++--------
 drivers/pci/quirks.c                    |   21 +-
 drivers/pci/slot.c                      |   48 ++
 include/linux/ioport.h                  |    4 +-
 include/linux/pci_ids.h                 |    4 +-
 include/linux/pci_regs.h                |    3 +-
 kernel/resource.c                       |   16 +-
 33 files changed, 1726 insertions(+), 740 deletions(-)
 create mode 100644 arch/x86/pci/broadcom_bus.c
