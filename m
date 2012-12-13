Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2LMLvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:51:15 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:36022 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2LMLvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:51:13 -0500
Date: Thu, 13 Dec 2012 12:51:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.8 merge window #1
Message-ID: <20121213125106.764f9d97@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12121311-3548-0000-0000-000003FDCE10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Add support to generate code for the latest machine zEC12, MOD and XOR
instruction support for the BPF jit compiler, the dasd safe offline
feature and the big one: the s390 architecture gets PCI support!!
Right before the world ends on the 21st ;-)

Christian Borntraeger (1):
      s390/kvm: Fix address space mixup

Cornelia Huck (1):
      s390: Add a mechanism to get the subchannel id.

Heiko Carstens (11):
      s390/mm,vmem: use 2GB frames for identity mapping
      s390/mm,vmemmap: use 1MB frames for vmemmap
      s390/traps: preinitialize program check table
      s390/mm: keep fault_init() private to fault.c
      s390/memory hotplug: use pfmf instruction to initialize storage keys
      s390/mm: move kernel_page_present/kernel_map_pages to page_attr.c
      s390/topology: cleanup topology code
      s390: add zEC12 code generation support
      s390/disassembler: add new instructions
      s390/bpf,jit: add support MOD instruction
      s390/bpf,jit: add support for XOR instruction

Ingo Tuchscherer (1):
      s390/zcrypt: msgType50 (RSA-CRT) fix

Jan Glauber (17):
      s390/qdio: rework BUG's and WARN_ON's
      s390/crypto: Don't panic after crypto instruction failures
      s390/pci: base support
      s390/pci: CLP interface
      s390/bitops: find leftmost bit instruction support
      s390/pci: PCI adapter interrupts for MSI/MSI-X
      s390/pci: DMA support
      s390/pci: CHSC PCI support for error and availability events
      s390/pci: PCI hotplug support via SCLP
      s390/pci: s390 specific PCI sysfs attributes
      s390/pci: add PCI Kconfig options
      vga: compile fix, disable vga for s390
      s390/pci: no msleep in potential IRQ context
      s390/pci: enable NEED_DMA_MAP_STATE
      s390/pci: speed up __iowrite64_copy by using pci store block insn
      s390/pci: remove obsolete email addresses
      s390/qdio: rename the misleading PCI flag of qdio devices

Martin Schwidefsky (1):
      s390/ptrace: race of single stepping vs signal delivery

Sebastian Ott (5):
      s390/dasd: fix multi-line printks with multiple KERN_<level>s
      s390: use ccw_device_get_schid
      s390/ccwgroup: set_online return error when already online
      s390/ccwgroup: allow drivers to call set_{on,off}line
      s390/cio: fix pgid reserved check

Stefan Haberland (2):
      s390/dasd: fix unaccessible device after resume
      s390/dasd: add safe offline interface

Wei Yongjun (2):
      s390/pci: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      s390/pci: fix potential NULL pointer dereference in dma_free_seg_table()

 arch/s390/Kbuild                       |    1 +
 arch/s390/Kconfig                      |   70 +-
 arch/s390/Makefile                     |    1 +
 arch/s390/crypto/aes_s390.c            |   18 +-
 arch/s390/crypto/des_s390.c            |   12 +-
 arch/s390/crypto/ghash_s390.c          |   21 +-
 arch/s390/crypto/sha_common.c          |    9 +-
 arch/s390/include/asm/bitops.h         |   81 +++
 arch/s390/include/asm/ccwdev.h         |    6 +-
 arch/s390/include/asm/ccwgroup.h       |    3 +
 arch/s390/include/asm/clp.h            |   28 +
 arch/s390/include/asm/dma-mapping.h    |   76 +++
 arch/s390/include/asm/dma.h            |   19 +-
 arch/s390/include/asm/hw_irq.h         |   22 +
 arch/s390/include/asm/io.h             |   55 +-
 arch/s390/include/asm/irq.h            |   12 +
 arch/s390/include/asm/isc.h            |    1 +
 arch/s390/include/asm/page.h           |    2 +
 arch/s390/include/asm/pci.h            |  156 ++++-
 arch/s390/include/asm/pci_clp.h        |  182 ++++++
 arch/s390/include/asm/pci_dma.h        |  196 ++++++
 arch/s390/include/asm/pci_insn.h       |  280 ++++++++
 arch/s390/include/asm/pci_io.h         |  194 ++++++
 arch/s390/include/asm/pgtable.h        |   11 +-
 arch/s390/include/asm/sclp.h           |    2 +
 arch/s390/include/asm/topology.h       |   34 +-
 arch/s390/include/asm/vga.h            |    6 +
 arch/s390/kernel/Makefile              |    2 +-
 arch/s390/kernel/dis.c                 |  578 +++++++++++------
 arch/s390/kernel/entry.S               |    7 +-
 arch/s390/kernel/entry.h               |   21 +-
 arch/s390/kernel/entry64.S             |   36 +-
 arch/s390/kernel/head.S                |   74 ++-
 arch/s390/kernel/irq.c                 |    2 +
 arch/s390/kernel/pgm_check.S           |  152 +++++
 arch/s390/kernel/setup.c               |   39 +-
 arch/s390/kernel/signal.c              |    2 +
 arch/s390/kernel/topology.c            |  113 ++--
 arch/s390/kernel/traps.c               |   52 +-
 arch/s390/mm/Makefile                  |   12 +-
 arch/s390/mm/dump_pagetables.c         |    7 +-
 arch/s390/mm/fault.c                   |   31 +-
 arch/s390/mm/init.c                    |   29 -
 arch/s390/mm/pageattr.c                |   82 ++-
 arch/s390/mm/pgtable.c                 |   16 -
 arch/s390/mm/vmem.c                    |   46 +-
 arch/s390/net/bpf_jit_comp.c           |   28 +
 arch/s390/pci/Makefile                 |    6 +
 arch/s390/pci/pci.c                    | 1103 ++++++++++++++++++++++++++++++++
 arch/s390/pci/pci_clp.c                |  324 ++++++++++
 arch/s390/pci/pci_dma.c                |  506 +++++++++++++++
 arch/s390/pci/pci_event.c              |   93 +++
 arch/s390/pci/pci_msi.c                |  141 ++++
 arch/s390/pci/pci_sysfs.c              |   86 +++
 drivers/gpu/vga/Kconfig                |    2 +-
 drivers/pci/hotplug/Kconfig            |   11 +
 drivers/pci/hotplug/Makefile           |    1 +
 drivers/pci/hotplug/s390_pci_hpc.c     |  252 ++++++++
 drivers/pci/msi.c                      |    6 +
 drivers/s390/block/dasd.c              |   97 ++-
 drivers/s390/block/dasd_devmap.c       |   34 +
 drivers/s390/block/dasd_eckd.c         |   92 ++-
 drivers/s390/block/dasd_fba.c          |   23 +-
 drivers/s390/block/dasd_int.h          |    2 +
 drivers/s390/block/dasd_ioctl.c        |   11 +-
 drivers/s390/char/sclp.h               |    3 +-
 drivers/s390/char/sclp_cmd.c           |   81 ++-
 drivers/s390/cio/ccwgroup.c            |   26 +-
 drivers/s390/cio/chsc.c                |  156 +++--
 drivers/s390/cio/device.c              |   11 -
 drivers/s390/cio/device.h              |    2 -
 drivers/s390/cio/device_ops.c          |   17 +-
 drivers/s390/cio/device_pgid.c         |   10 +-
 drivers/s390/cio/qdio_main.c           |   52 +-
 drivers/s390/cio/qdio_setup.c          |    9 +-
 drivers/s390/cio/qdio_thinint.c        |    2 -
 drivers/s390/crypto/zcrypt_msgtype50.c |   68 +-
 drivers/s390/crypto/zcrypt_msgtype50.h |    2 +
 include/asm-generic/io.h               |   21 +-
 include/linux/irq.h                    |   10 +-
 80 files changed, 5313 insertions(+), 774 deletions(-)
 create mode 100644 arch/s390/include/asm/clp.h
 create mode 100644 arch/s390/include/asm/dma-mapping.h
 create mode 100644 arch/s390/include/asm/hw_irq.h
 create mode 100644 arch/s390/include/asm/pci_clp.h
 create mode 100644 arch/s390/include/asm/pci_dma.h
 create mode 100644 arch/s390/include/asm/pci_insn.h
 create mode 100644 arch/s390/include/asm/pci_io.h
 create mode 100644 arch/s390/include/asm/vga.h
 create mode 100644 arch/s390/kernel/pgm_check.S
 create mode 100644 arch/s390/pci/Makefile
 create mode 100644 arch/s390/pci/pci.c
 create mode 100644 arch/s390/pci/pci_clp.c
 create mode 100644 arch/s390/pci/pci_dma.c
 create mode 100644 arch/s390/pci/pci_event.c
 create mode 100644 arch/s390/pci/pci_msi.c
 create mode 100644 arch/s390/pci/pci_sysfs.c
 create mode 100644 drivers/pci/hotplug/s390_pci_hpc.c

