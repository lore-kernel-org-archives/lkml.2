Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0JUOdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:33:44 -0400
Received: from www.tglx.de ([62.245.132.106]:39425 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0JUOdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:33:42 -0400
Date: Thu, 21 Oct 2010 16:33:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] genirq core for 2.6.37
Message-ID: <alpine.LFD.2.00.1010211628010.2418@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus

Please pull this after x86/x2apic and x86/cleanups.

Both branches have been merged into irq/core to avoid massive
conflicts. The changelog below is against 2.6.36 + x86/x2apic and
x86/cleanups.

Thanks,

	tglx
---
Anand Gadiyar (1):
      genirq, ARM: Fix boot on ARM platforms

Ingo Molnar (1):
      Merge branch 'linus' into irq/core

Robert Richter (2):
      apic, x86: Check if EILVT APIC registers are available (AMD only)
      apic, x86: Use BIOS settings for IBS and MCE threshold interrupt LVT offsets

Thomas Gleixner (94):
      MAINTAINERS: Add IRQ subsystem
      genirq: Cleanup irq_chip->typename leftovers
      mfd: Rename struct irq_data to struct sih_irq_data
      isdn: Free irq_data namespace
      genirq: Provide Kconfig
      x86: Use genirq Kconfig
      genirq: Create irq_data
      genirq: Convert core code to irq_data
      genirq: Provide advanced irq chip functions
      genirq: Add new functions to dummy chips
      genirq: Provide compat handling for bus_lock/bus_sync_unlock
      genirq: Provide compat handling for chip->mask()
      genirq: Provide compat handling for chip->unmask()
      genirq: Provide compat handling for chip->ack()
      genirq: Provide compat handling for chip->mask_ack()
      genirq: Provide compat handling for chip->eoi()
      genirq: Provide compat handling for chip->enable()
      genirq: Provide compat handling for chip->disable()/shutdown()
      genirq: Provide compat handling for chip->startup()
      genirq: Provide compat handling for chip->set_affinity()
      genirq: Provide compat handling for chip->set_type()
      genirq: Provide compat handling for chip->set_wake()
      genirq: Provide compat handling for chip->retrigger()
      genirq: Provide config option to disable deprecated code
      mfd: twl4030: Fix dummy irq chip usage
      genirq: Distangle irq.h
      genirq: Remove unsused inline
      genirq: Provide status modifier
      genirq: Sanitize irq_data accessors
      genirq: Distangle kernel/irq/handle.c
      genirq: Remove early_init_irq_lock_class()
      isdn: hisax: Replace the bogus access to irq stats
      genirq: Remove export of kstat_irqs_cpu
      genirq: Provide default irq init flags
      genirq: Implement a sane sparse_irq allocator
      genirq: Prepare proc for real sparse irq support
      genirq: Implement sane enumeration
      genirq: Implement irq reservation
      genirq-update-kerneldoc.patch
      genirq: Use sane sparse allocator
      genirq: Query arch for number of early descriptors
      Merge branch 'x86/x2apic' into irq/sparseirq
      Merge branch 'x86/cleanups' into irq/sparseirq
      Merge branch 'x86/urgent' of into irq/sparseirq
      pci: Convert msi to new irq_chip functions
      pci: Cleanup the irq_desc mess in msi
      x86: Remove useless reinitialization of irq descriptors
      x86: Convert irq_chip access to new functions
      x86: Sanitize apb timer interrupt handling
      x86: lguest: Convert to new irq chip functions
      x86: Cleanup visws interrupt handling
      x86: i8259: Convert to new irq_chip functions
      x86: Cleanup access to irq_data
      x86: Cleanup io_apic
      x86: io_apic: Convert startup to new irq_chip function
      x86: ioapic: Convert mask to new irq_chip function
      x86: ioapic/hpet: Convert to new chip functions
      dmar: Convert to new irq chip functions
      ht: Convert to new irq_chip functions
      x86: ioapic: Clean up the direct access to irq_desc
      x86: Prepare the affinity common functions for taking struct irq_data *
      x86: Convert msi affinity setting to new chip functions
      x86: Convert remapped ioapic affinity setting to new irq chip function
      x86: Convert remapped msi to new chip.irq_set_affinity function
      x86: Convert dmar affinity setting to new chip function
      x86: Cleanup hpet affinity setting
      x86: Convert ht set_affinity to new chip function
      x86: ioapic: Cleanup some more
      x86: ioapic: Cleanup get_one_free_irq_cfg()
      x86: Implement new allocator functions
      x86: io_apic: Prepare alloc/free_irq_cfg()
      x86: ioapic: Cleanup sparse irq code
      x86: io_apic: Remove the now unused sparse_irq arch_* functions
      pci: intr-remap: Free irte memory if SPARSE_IRQ=y
      pci: intr_remap: Use irq_data
      pci: intr_remap: Remove unused functions
      x86: Embedd irq_2_iommu into irq_cfg
      intr_remap: Use irq_2_iommu in struct irq_cfg
      intr_remap: Simplify the code further
      x86: Speed up the irq_remapped check in hot pathes
      genirq: Remove irq_2_iommu
      x86: Make io_apic.c local functions static
      x86: uv: Clean up the direct access to irq_desc
      x86: Use sane enumeration
      x86: xen: Sanitise sparse_irq handling
      genirq: Remove arch_init_chip_data()
      genirq: Sanitize dynamic irq handling
      genirq: Remove the now unused sparse irq leftovers
      x86: lguest: Use new irq allocator
      genirq: Make sparse_lock a mutex
      genirq: Switch sparse_irq allocator to GFP_KERNEL
      x86: Switch sparse_irq allocations to GFP_KERNEL
      genirq: Fix CONFIG_GENIRQ_NO_DEPRECATED=y build
      arm: Use ARCH_IRQ_INIT_FLAGS

Yinghai Lu (2):
      x86: Don't setup ioapic irq for sci twice
      x86: ioapic: Call free_irte only if interrupt remapping enabled

 Documentation/DocBook/genericirq.tmpl  |   84 ++--
 MAINTAINERS                            |    6 +
 arch/arm/include/asm/hw_irq.h          |    2 +
 arch/arm/kernel/irq.c                  |   10 +-
 arch/arm/mach-bcmring/irq.c            |    6 +-
 arch/arm/mach-iop13xx/msi.c            |    8 +-
 arch/ia64/kernel/msi_ia64.c            |    8 +-
 arch/ia64/sn/kernel/msi_sn.c           |    4 +-
 arch/m32r/kernel/irq.c                 |    2 +-
 arch/m32r/platforms/m32104ut/setup.c   |    2 +-
 arch/m32r/platforms/m32700ut/setup.c   |    8 +-
 arch/m32r/platforms/mappi/setup.c      |    2 +-
 arch/m32r/platforms/mappi2/setup.c     |    2 +-
 arch/m32r/platforms/mappi3/setup.c     |    2 +-
 arch/m32r/platforms/oaks32r/setup.c    |    2 +-
 arch/m32r/platforms/opsput/setup.c     |    6 +-
 arch/m32r/platforms/usrv/setup.c       |    4 +-
 arch/powerpc/platforms/cell/axon_msi.c |    6 +-
 arch/powerpc/platforms/pseries/xics.c  |    2 +-
 arch/powerpc/sysdev/fsl_msi.c          |    4 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c  |   22 +-
 arch/powerpc/sysdev/mpic_u3msi.c       |   18 +-
 arch/sh/kernel/irq.c                   |    2 +-
 arch/sparc/kernel/pci_msi.c            |    8 +-
 arch/tile/kernel/irq.c                 |    4 +-
 arch/um/kernel/irq.c                   |    6 +-
 arch/x86/Kconfig                       |   35 +--
 arch/x86/include/asm/apic.h            |    4 +-
 arch/x86/include/asm/apicdef.h         |    1 +
 arch/x86/include/asm/hpet.h            |   10 +-
 arch/x86/include/asm/hw_irq.h          |   17 +-
 arch/x86/include/asm/i8259.h           |    2 +
 arch/x86/include/asm/io_apic.h         |    6 -
 arch/x86/include/asm/irq_remapping.h   |    8 +
 arch/x86/kernel/apb_timer.c            |   54 +--
 arch/x86/kernel/apic/apic.c            |   88 +++-
 arch/x86/kernel/apic/io_apic.c         |  849 ++++++++++++--------------------
 arch/x86/kernel/apic/nmi.c             |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c   |   27 +-
 arch/x86/kernel/hpet.c                 |   16 +-
 arch/x86/kernel/i8259.c                |   63 ++--
 arch/x86/kernel/irq.c                  |   24 +-
 arch/x86/kernel/irqinit.c              |   17 +-
 arch/x86/kernel/smpboot.c              |    4 +-
 arch/x86/kernel/uv_irq.c               |   55 +--
 arch/x86/kernel/visws_quirks.c         |  140 ++----
 arch/x86/lguest/boot.c                 |   18 +-
 arch/x86/oprofile/op_model_amd.c       |  145 +++++-
 arch/xtensa/kernel/irq.c               |    2 +-
 drivers/isdn/act2000/act2000.h         |    6 +-
 drivers/isdn/hisax/config.c            |   18 +-
 drivers/isdn/hisax/hisax.h             |    1 +
 drivers/mfd/twl4030-irq.c              |    4 +-
 drivers/pci/dmar.c                     |    8 +-
 drivers/pci/htirq.c                    |   22 +-
 drivers/pci/intr_remapping.c           |  212 +-------
 drivers/pci/msi.c                      |   38 +-
 drivers/xen/events.c                   |   23 +-
 include/linux/dmar.h                   |   10 +-
 include/linux/htirq.h                  |    5 +-
 include/linux/interrupt.h              |    3 -
 include/linux/irq.h                    |  447 +++++++-----------
 include/linux/irqdesc.h                |  159 ++++++
 include/linux/irqnr.h                  |    5 +
 include/linux/lockdep.h                |    8 -
 include/linux/msi.h                    |   13 +-
 init/Kconfig                           |    2 +
 init/main.c                            |    1 -
 kernel/irq/Kconfig                     |   53 ++
 kernel/irq/Makefile                    |    3 +-
 kernel/irq/autoprobe.c                 |   15 +-
 kernel/irq/chip.c                      |  378 ++++++++-------
 kernel/irq/dummychip.c                 |   68 +++
 kernel/irq/handle.c                    |  341 +-------------
 kernel/irq/internals.h                 |   39 +-
 kernel/irq/irqdesc.c                   |  395 +++++++++++++++
 kernel/irq/manage.c                    |   87 ++--
 kernel/irq/migration.c                 |   12 +-
 kernel/irq/numa_migrate.c              |  120 -----
 kernel/irq/proc.c                      |   26 +-
 kernel/irq/resend.c                    |    5 +-
 kernel/irq/spurious.c                  |    8 +-
 kernel/softirq.c                       |    9 +-
 83 files changed, 2135 insertions(+), 2226 deletions(-)
 create mode 100644 include/linux/irqdesc.h
 create mode 100644 kernel/irq/Kconfig
 create mode 100644 kernel/irq/dummychip.c
 create mode 100644 kernel/irq/irqdesc.c
 delete mode 100644 kernel/irq/numa_migrate.c


