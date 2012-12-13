Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2LMA3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:29:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab2LMA3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:29:19 -0500
Date: Wed, 12 Dec 2012 16:28:06 -0800
Message-Id: <201212130028.qBD0S6Qb032540@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/acpi changes for v3.8
Cc: David Rientjes <rientjes@google.com>,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Thomas Renninger <trenn@suse.de>,
        Tony Luck <tony.luck@intel.com>, Yinghai Lu <yinghai@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 12 Dec 2012 16:28:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a patchset which didn't make the last merge window.  It adds a
debugging capability to feed ACPI tables via the initramfs.

On a grander scope, it formalizes using the initramfs protocol for
feeding arbitrary blobs which need to be accessed early to the kernel:
they are fed first in the initramfs blob (lots of bootloaders can
concatenate this at boot time, others can use a single file) in an
uncompressed cpio archive using filenames starting with "kernel/".

The ACPI maintainers requested that this patchset be fed via the x86
tree rather than the ACPI tree as the footprint in the general x86
code is much bigger than in the ACPI code proper.

	-hpa


The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-acpi-for-linus

David Rientjes (1):
      ACPI: Fix build when disabled

H. Peter Anvin (1):
      lib: Add early cpio decoder

Thomas Renninger (5):
      x86, acpi: Introduce x86 arch specific arch_reserve_mem_area() for e820 handling
      ACPI: Store valid ACPI tables passed via early initrd in reserved memblock areas
      ACPI: Implement physical address table override
      ACPI: Create acpi_table_taint() function to avoid code duplication
      ACPI: Document ACPI table overriding via initrd

Tony Luck (1):
      X86 ACPI: Use #ifdef not #if for CONFIG_X86 check

 Documentation/acpi/initrd_table_override.txt |   94 ++++++++++++
 arch/x86/kernel/acpi/boot.c                  |    6 +
 arch/x86/kernel/setup.c                      |    4 +
 drivers/acpi/Kconfig                         |    9 +
 drivers/acpi/osl.c                           |  202 ++++++++++++++++++++++++--
 include/linux/acpi.h                         |   16 ++
 include/linux/earlycpio.h                    |   17 ++
 lib/Makefile                                 |    2 +-
 lib/earlycpio.c                              |  145 ++++++++++++++++++
 9 files changed, 483 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/acpi/initrd_table_override.txt
 create mode 100644 include/linux/earlycpio.h
 create mode 100644 lib/earlycpio.c
