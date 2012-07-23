Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2GWPWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:22:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46715 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2GWPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:22:39 -0400
Date: Mon, 23 Jul 2012 11:13:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, david.vrabel@citrix.com,
        yunhong.jiang@intel.com, liping.ke@intel.com, jinsong.liu@intel.com,
        olaf@aepfle.de, zhenzhong.duan@oracle.com, borislav.petkov@amd.com,
        bp@amd64.org
Subject: [GIT PULL] (xen) stable/for-linus-3.6-rc0-tag
Message-ID: <20120723151332.GB21870@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.6-rc0-tag

which has three nice features and various bug-fixes. A nice summary of them is included
in the git tag. A shorter summary is that two of them are patches mainly for
enterprise machines - to collect MCE data and also offline/online CPUs. Then there is
performance improvements to minimize the amount of traps done to the hypervisor.
And then there are some little fixes. The biggest one is to make PVonHVM guest able
to successfully do an kexec 100% instead of "most" of the time - there were certain
pages that ended up being stamped by the hypervisor after the new kernel was booted -
the patches fix that.

Here is the diff stat.

 .../ABI/testing/sysfs-devices-system-xen_cpu       |   20 +
 arch/x86/include/asm/xen/hypercall.h               |    8 +
 arch/x86/kernel/cpu/mcheck/mce.c                   |    4 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c               |   22 +-
 arch/x86/xen/enlighten.c                           |  224 ++++++++---
 arch/x86/xen/mmu.c                                 |   39 ++-
 arch/x86/xen/setup.c                               |   23 +-
 arch/x86/xen/suspend.c                             |    2 +-
 arch/x86/xen/xen-ops.h                             |    2 +-
 drivers/tty/hvc/hvc_xen.c                          |   15 +-
 drivers/xen/Kconfig                                |    8 +
 drivers/xen/Makefile                               |    2 +
 drivers/xen/mcelog.c                               |  414 ++++++++++++++++++++
 drivers/xen/pcpu.c                                 |  371 ++++++++++++++++++
 drivers/xen/platform-pci.c                         |   18 +
 drivers/xen/xen-acpi-processor.c                   |    9 +-
 drivers/xen/xenbus/xenbus_xs.c                     |   20 +
 include/linux/miscdevice.h                         |    1 +
 include/xen/events.h                               |    2 +
 include/xen/interface/io/xs_wire.h                 |    3 +-
 include/xen/interface/platform.h                   |    8 +
 include/xen/interface/xen-mca.h                    |  385 ++++++++++++++++++
 include/xen/interface/xen.h                        |    1 +
 23 files changed, 1511 insertions(+), 90 deletions(-)

David Vrabel (4):
      xen/mm: do direct hypercall in xen_set_pte() if batching is unavailable
      xen/mm: zero PTEs for non-present MFNs in the initial page table
      xen/x86: add desc_equal() to compare GDT descriptors
      xen/x86: avoid updating TLS descriptors if they haven't changed

Konrad Rzeszutek Wilk (2):
      xen/acpi: Fix potential memory leak.
      xen/hvc: Fix up checks when the info is allocated.

Liu, Jinsong (6):
      xen/mce: Add mcelog support for Xen platform
      x86, MCE, AMD: Adjust initcall sequence for xen
      xen/mce: Register native mce handler as vMCE bounce back point
      xen/pcpu: Xen physical cpus online/offline sys interface
      xen/mce: schedule a workqueue to avoid sleep in atomic context
      xen/mce: add .poll method for mcelog device driver

Olaf Hering (5):
      xen/pv-on-hvm kexec: shutdown watches from old kernel
      xen: enable platform-pci only in a Xen guest
      xen: remove cast from HYPERVISOR_shared_info assignment
      xen: simplify init_hvm_pv_info
      xen PVonHVM: move shared_info to MMIO before kexec

zhenzhong.duan (1):
      xen: populate correct number of pages when across mem boundary (v2)

