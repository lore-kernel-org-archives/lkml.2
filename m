Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0KVUbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:31:06 -0500
Received: from claw.goop.org ([74.207.240.146]:36146 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab0KVUbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:31:04 -0500
Message-ID: <4CEAD307.50409@goop.org>
Date: Mon, 22 Nov 2010 12:31:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: [GIT PULL] Xen updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some more Xen-related bugfixes, including:

    * Xen evtchn driver fixes, including fixing some locking fixes, and
      giving it a more standard name
    * Xen xenfs updates, including removing a bogus address space (when
      really we needed VM_PFNMAP) and fixing the prototype for mount
    * fix 32-on-64 dom0 booting, and make sure IO port permissions are
      enabled early to fix booting on AMD systems
    * make sure the balloon driver only claims E820_RAM pages

Available at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git upstream/for-linus

Bastian Blank (1):
      xen/evtchn: Fix name of Xen event-channel device

Ian Campbell (2):
      xen: implement XENMEM_machphys_mapping
      xen: make evtchn's name less generic

Jan Beulich (1):
      xen/evtchn: clear secondary CPUs' cpu_evtchn_mask[] after restore

Jeremy Fitzhardinge (17):
      xen/evtchn: track enabled state for each port
      xen/evtchn: dynamically allocate port_user array
      xen/evtchn: ports start enabled
      xen/evtchn: remove spurious barrier
      xen/evtchn: don't do unbind_from_irqhandler under spinlock
      xen/evtchn: add missing static
      Merge commit 'v2.6.37-rc2' into upstream/xenfs
      xen/xenfs: update xenfs_mount for new prototype
      xen/events: use locked set|clear_bit() for cpu_evtchn_mask
      Revert "xen/privcmd: create address space to allow writable mmaps"
      xen/evtchn: the evtchn device is non-seekable
      Merge branch 'xen/dev-evtchn' into upstream/evtchn
      xen: add extra pages to balloon
      xen/balloon: the balloon_lock is useless
      xen/balloon: make sure we only include remaining extra ram
      xen: re-enable boot-time ballooning
      Merge branches 'upstream/core', 'upstream/xenfs' and 'upstream/evtchn' into upstream/for-linus

Konrad Rzeszutek Wilk (2):
      xen: set IO permission early (before early_cpu_init())
      xen/events: Use PIRQ instead of GSI value when unmapping MSI/MSI-X irqs.

Randy Dunlap (1):
      xen: fix header export to userspace

Stefano Stabellini (1):
      xen: set vma flag VM_PFNMAP in the privcmd mmap file_op

Vasiliy Kulikov (1):
      xen: xenfs: privcmd: check put_user() return code

 arch/x86/include/asm/xen/interface.h    |    6 +-
 arch/x86/include/asm/xen/interface_32.h |    5 ++
 arch/x86/include/asm/xen/interface_64.h |   13 +----
 arch/x86/include/asm/xen/page.h         |    7 +-
 arch/x86/xen/enlighten.c                |   19 ++++++-
 arch/x86/xen/mmu.c                      |   17 +++++-
 arch/x86/xen/setup.c                    |   11 +---
 drivers/xen/Makefile                    |    5 +-
 drivers/xen/balloon.c                   |   32 +++++-----
 drivers/xen/events.c                    |   13 +++--
 drivers/xen/evtchn.c                    |  100 +++++++++++++++++++++++-------
 drivers/xen/xenfs/privcmd.c             |   13 ++---
 drivers/xen/xenfs/super.c               |   46 ++------------
 include/xen/interface/memory.h          |   13 ++++
 include/xen/page.h                      |    7 ++
 include/xen/privcmd.h                   |    5 +-
 16 files changed, 186 insertions(+), 126 deletions(-)

Thanks,
	J

