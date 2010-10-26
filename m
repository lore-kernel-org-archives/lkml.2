Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab0JZXpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 19:45:43 -0400
Received: from claw.goop.org ([74.207.240.146]:48504 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab0JZXpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 19:45:42 -0400
Message-ID: <4CC7681B.9060301@goop.org>
Date: Tue, 26 Oct 2010 16:45:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: [GIT PULL] Xen updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Linus,

Here's a series of Xen core changes for 2.6.37.  I pre-merged with your
tree mainly this codes adds a call to reserve_early(), which needed to
be updated to the memblock equivalent.  I've also given you the
reference to the unmerged branches.

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xen

Unmerged branches:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/core
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/xenfs


Thanks,
	J


Ian Campbell (9):
      xen: add /proc/xen/xsd_{kva,port} to xenfs
      privcmd: MMAPBATCH: Fix error handling/reporting
      xen/privcmd: move remap_domain_mfn_range() to core xen code and export.
      xen: Use host-provided E820 map
      xen: ensure that all event channels start off bound to VCPU 0
      xen: improvements to VIRQ_DEBUG output
      xen: correctly rebuild mfn list list after migration.
      xen: use host E820 map for dom0
      xen: include xen/xen.h for definition of xen_initial_domain()

Jeremy Fitzhardinge (34):
      xen: add xen_set_domain_pte()
      xen: add variable hypercall caller
      xen: add privcmd driver
      xen/privcmd: create address space to allow writable mmaps
      xen/xenfs: set_page_dirty is supposed to return true if it dirties
      xen/privcmd: print SIGBUS faults
      xen/privcmd: make sure vma is ours before doing anything to it
      xenbus: export xen_store_interface for xenfs
      xen/privcmd: make privcmd visible in domU
      x86: add RESERVE_BRK_ARRAY() helper
      xen: dynamically allocate p2m space
      xen: allocate p2m size based on actual max size
      xen: use early_brk for level2_kernel_pgt
      xen: allocate level1_ident_pgt
      xen: remove noise about registering vcpu info
      xen/events: change to using fasteoi
      xen: set shared_info->arch.max_pfn to max_p2m_pfn
      xen: set the actual extent of the mfn_list_list
      xen: make install_p2mtop_page() static
      xen: convert p2m to a 3 level tree
      xen: add return value to set_phys_to_machine()
      xen: defer building p2m mfn structures until kernel is mapped
      xen: don't map missing memory
      xen: implement "extra" memory to reserve space for pages not present at boot
      xen: make sure xen_extra_mem_start is beyond all non-RAM e820
      xen: add extra pages for E820 RAM regions, even if beyond mem_end
      xen: limit extra memory to a certain ratio of base
      xen: make sure xen_max_p2m_pfn is up to date
      xen: add support for PAT
      xen: don't add extra_pages for RAM after mem_end
      xen/hvc: only notify if we actually sent something
      xen: set up IRQ before binding virq to evtchn
      Merge branch 'upstream/xenfs' into upstream/xen
      Merge branch 'upstream/core' into upstream/xen

 arch/x86/include/asm/xen/hypercall.h |   17 ++
 arch/x86/include/asm/xen/page.h      |   12 +-
 arch/x86/xen/Kconfig                 |   11 +-
 arch/x86/xen/enlighten.c             |   16 +-
 arch/x86/xen/mmu.c                   |  501 ++++++++++++++++++++++++++++-----
 arch/x86/xen/mmu.h                   |    1 -
 arch/x86/xen/setup.c                 |  112 ++++++++-
 arch/x86/xen/xen-ops.h               |    3 +
 drivers/char/hvc_xen.c               |    3 +-
 drivers/xen/events.c                 |  101 +++++---
 drivers/xen/xenbus/xenbus_probe.c    |    4 +-
 drivers/xen/xenfs/Makefile           |    3 +-
 drivers/xen/xenfs/privcmd.c          |  404 +++++++++++++++++++++++++++
 drivers/xen/xenfs/super.c            |   95 ++++++-
 drivers/xen/xenfs/xenfs.h            |    3 +
 drivers/xen/xenfs/xenstored.c        |   68 +++++
 include/xen/Kbuild                   |    1 +
 include/xen/interface/memory.h       |   29 ++
 include/xen/privcmd.h                |   80 ++++++
 include/xen/xen-ops.h                |    5 +
 20 files changed, 1332 insertions(+), 137 deletions(-)
 create mode 100644 drivers/xen/xenfs/privcmd.c
 create mode 100644 drivers/xen/xenfs/xenstored.c


