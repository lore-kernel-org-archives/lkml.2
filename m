Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1G1Xvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:51:44 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57695 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932076Ab1G1Xvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:51:41 -0400
Date: Thu, 28 Jul 2011 16:51:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI changes
Message-ID: <20110728165132.5d7bec4d@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
a2fa83faf47b514ab947cea916d3691b66525073:

  Merge branch 'usb-linus' of
  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
  (2011-07-05 20:57:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
  linux-next


Nothing too terribly exciting... my reference tree doesn't include the
realloc patch, so this lists it as one of the changes, but it should be
a dupe of what's already in your tree.

Ram has a couple of more changes coming (that will hide behind
pci=realloc), I'll send those in a later pull request.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center


Bjorn Helgaas (4):
      x86/PCI: reduce severity of host bridge window conflict warnings
      PCI: treat mem BAR type "11" (reserved) as 32-bit, not 64-bit, BAR
      PCI: fold pci_calc_resource_flags() into decode_bar()
      PCI: remove printks about disabled bridge windows

Chris Wright (1):
      PCI: ARI is a PCIe v2 feature

Huang Ying (1):
      PCI: PCIe AER: add aer_recover_queue

Jan Beulich (1):
      x86/PCI: config space accessor functions should not ignore the
segment argument

Jon Mason (1):
      PCI: correct pcie_set_readrq write size

Kenji Kaneshige (1):
      PCI: pciehp: change wait time for valid configuration access

Myron Stowe (1):
      PCI: Assign values to 'pci_obff_signal_type' enumeration constants

Narendra_K@Dell.com (1):
      x86/PCI: Preserve existing pci=bfsort whitelist for Dell systems

Ralf Baechle (1):
      PCI: Make the struct pci_dev * argument of pci_fixup_irqs const.

Ram Pai (1):
      PCI: conditional resource-reallocation through kernel parameter
pci=realloc

Sergei Shtylyov (2):
      PCI hotplug: cpqphp: use pci_dev->subsystem_{vendor|device}
      PCI hotplug: cpqphp: use pci_dev->vendor

Shaohua Li (1):
      x86/PCI: select direct access mode for mmconfig option

Thomas Renninger (1):
      PCI hotplug: Rename is_ejectable which also exists in dock.c

Tiejun Chen (1):
      PCI: enumerate the PCI device only removed out PCI hieratchy of
OS when re-scanning PCI

tip-bot for Sergei Shtylyov (1):
      x86/PCI: quirks: Use pci_dev->revision

 Documentation/kernel-parameters.txt            |    2 +
 arch/alpha/kernel/sys_alcor.c                  |    2 +-
 arch/alpha/kernel/sys_cabriolet.c              |    6 +-
 arch/alpha/kernel/sys_dp264.c                  |    8 +-
 arch/alpha/kernel/sys_eb64p.c                  |    2 +-
 arch/alpha/kernel/sys_eiger.c                  |    2 +-
 arch/alpha/kernel/sys_marvel.c                 |    2 +-
 arch/alpha/kernel/sys_miata.c                  |    2 +-
 arch/alpha/kernel/sys_mikasa.c                 |    2 +-
 arch/alpha/kernel/sys_nautilus.c               |    2 +-
 arch/alpha/kernel/sys_noritake.c               |    2 +-
 arch/alpha/kernel/sys_rawhide.c                |    2 +-
 arch/alpha/kernel/sys_ruffian.c                |    2 +-
 arch/alpha/kernel/sys_rx164.c                  |    2 +-
 arch/alpha/kernel/sys_sable.c                  |    4 +-
 arch/alpha/kernel/sys_sio.c                    |    4 +-
 arch/alpha/kernel/sys_sx164.c                  |    2 +-
 arch/alpha/kernel/sys_takara.c                 |    4 +-
 arch/alpha/kernel/sys_titan.c                  |    2 +-
 arch/alpha/kernel/sys_wildfire.c               |    2 +-
 arch/arm/common/it8152.c                       |    2 +-
 arch/arm/include/asm/hardware/it8152.h         |    2 +-
 arch/arm/include/asm/mach/pci.h                |    4 +-
 arch/arm/kernel/bios32.c                       |    2 +-
 arch/arm/mach-cns3xxx/pcie.c                   |    2 +-
 arch/arm/mach-dove/pcie.c                      |    2 +-
 arch/arm/mach-footbridge/cats-pci.c            |    2 +-
 arch/arm/mach-footbridge/ebsa285-pci.c         |    2 +-
 arch/arm/mach-footbridge/netwinder-pci.c       |    2 +-
 arch/arm/mach-footbridge/personal-pci.c        |    3 +-
 arch/arm/mach-integrator/pci.c                 |    2 +-
 arch/arm/mach-iop13xx/iq81340mc.c              |    2 +-
 arch/arm/mach-iop13xx/pci.c                    |    2 +-
 arch/arm/mach-iop32x/em7210.c                  |    2 +-
 arch/arm/mach-iop32x/glantank.c                |    2 +-
 arch/arm/mach-iop32x/iq31244.c                 |    4 +-
 arch/arm/mach-iop32x/iq80321.c                 |    2 +-
 arch/arm/mach-iop32x/n2100.c                   |    2 +-
 arch/arm/mach-iop33x/iq80331.c                 |    2 +-
 arch/arm/mach-iop33x/iq80332.c                 |    2 +-
 arch/arm/mach-ixp2000/enp2611.c                |    3 +-
 arch/arm/mach-ixp2000/ixdp2400.c               |    3 +-
 arch/arm/mach-ixp2000/ixdp2800.c               |    3 +-
 arch/arm/mach-ixp2000/ixdp2x01.c               |    3 +-
 arch/arm/mach-ixp23xx/ixdp2351.c               |    2 +-
 arch/arm/mach-ixp23xx/roadrunner.c             |    3 +-
 arch/arm/mach-ixp4xx/avila-pci.c               |    2 +-
 arch/arm/mach-ixp4xx/coyote-pci.c              |    2 +-
 arch/arm/mach-ixp4xx/dsmg600-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/fsg-pci.c                 |    2 +-
 arch/arm/mach-ixp4xx/gateway7001-pci.c         |    3 +-
 arch/arm/mach-ixp4xx/goramo_mlr.c              |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-pci.c            |    2 +-
 arch/arm/mach-ixp4xx/ixdp425-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/ixdpg425-pci.c            |    2 +-
 arch/arm/mach-ixp4xx/nas100d-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/nslu2-pci.c               |    2 +-
 arch/arm/mach-ixp4xx/vulcan-pci.c              |    2 +-
 arch/arm/mach-ixp4xx/wg302v2-pci.c             |    2 +-
 arch/arm/mach-kirkwood/pcie.c                  |    3 +-
 arch/arm/mach-ks8695/board-dsm320.c            |    2 +-
 arch/arm/mach-ks8695/board-micrel.c            |    2 +-
 arch/arm/mach-ks8695/include/mach/devices.h    |    2 +-
 arch/arm/mach-mv78xx0/pcie.c                   |    3 +-
 arch/arm/mach-orion5x/common.h                 |    2 +-
 arch/arm/mach-orion5x/db88f5281-setup.c        |    3 +-
 arch/arm/mach-orion5x/dns323-setup.c           |    4 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c      |    3 +-
 arch/arm/mach-orion5x/mss2-setup.c             |    2 +-
 arch/arm/mach-orion5x/pci.c                    |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c   |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c    |    2 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c        |    3 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c |    2 +-
 arch/arm/mach-orion5x/ts209-setup.c            |    3 +-
 arch/arm/mach-orion5x/ts409-setup.c            |    3 +-
 arch/arm/mach-orion5x/wnr854t-setup.c          |    3 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c       |    3 +-
 arch/arm/mach-pxa/cm-x2xx-pci.c                |    2 +-
 arch/arm/mach-sa1100/pci-nanoengine.c          |    3 +-
 arch/arm/mach-shark/pci.c                      |    2 +-
 arch/arm/mach-tegra/pcie.c                     |    2 +-
 arch/arm/mach-versatile/pci.c                  |    2 +-
 arch/sh/drivers/pci/fixups-cayman.c            |    2 +-
 arch/sh/drivers/pci/fixups-dreamcast.c         |    2 +-
 arch/sh/drivers/pci/fixups-landisk.c           |    2 +-
 arch/sh/drivers/pci/fixups-r7780rp.c           |    2 +-
 arch/sh/drivers/pci/fixups-rts7751r2d.c        |    2 +-
 arch/sh/drivers/pci/fixups-sdk7780.c           |    2 +-
 arch/sh/drivers/pci/fixups-se7751.c            |    2 +-
 arch/sh/drivers/pci/fixups-sh03.c              |    2 +-
 arch/sh/drivers/pci/fixups-snapgear.c          |    2 +-
 arch/sh/drivers/pci/fixups-titan.c             |    2 +-
 arch/sh/drivers/pci/pcie-sh7786.c              |    2 +-
 arch/sh/include/asm/pci.h                      |    2 +-
 arch/sparc/include/asm/leon_pci.h              |    2 +-
 arch/sparc/kernel/leon_pci_grpci2.c            |    2 +-
 arch/tile/kernel/pci.c                         |    2 +-
 arch/unicore32/kernel/pci.c                    |    2 +-
 arch/x86/Kconfig                               |    2 +-
 arch/x86/kernel/quirks.c                       |    5 +-
 arch/x86/pci/acpi.c                            |    7 +-
 arch/x86/pci/ce4100.c                          |    2 +
 arch/x86/pci/common.c                          |   14 ++--
 arch/x86/pci/direct.c                          |    6 +-
 arch/x86/pci/numaq_32.c                        |    2 +
 arch/x86/pci/olpc.c                            |    4 +
 arch/x86/pci/pcbios.c                          |    2 +
 arch/x86/pci/visws.c                           |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c               |    6 +-
 drivers/pci/hotplug/cpqphp_core.c              |   17 ++---
 drivers/pci/hotplug/pciehp_ctrl.c              |    3 +
 drivers/pci/hotplug/pciehp_hpc.c               |   11 +---
 drivers/pci/pci.c                              |   13 +++-
 drivers/pci/pci.h                              |    2 +
 drivers/pci/pcie/aer/aerdrv_core.c             |   76
 ++++++++++++++++++-- drivers/pci/pcie/aer/aerdrv_errprint.c
 |    3 +- drivers/pci/probe.c                            |   89
 +++++++++++-------------
 drivers/pci/setup-bus.c                        |   18 ++++-
 drivers/pci/setup-irq.c                        |    4 +-
 drivers/pci/setup-res.c                        |    3 +-
 include/linux/aer.h                            |    3 +
 include/linux/pci.h                            |    6 +- 123 files
 changed, 318 insertions(+), 219 deletions(-)


