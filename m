Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab1CXSDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1CXSDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:03:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, tglx@linutronix.de, amwang@redhat.com,
        vapier@gentoo.org, lethal@linux-sh.org
Subject: [GIT PULL] NOMMU and FRV patches
Date: Thu, 24 Mar 2011 18:03:04 +0000
Message-ID: <27521.1300989784@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you pull these patches please?

There are a number of fixes for NOMMU: fixes for percpu to deal with breakage
due to MMU-mode changes and fixes for the firmware loader to make it work at
all.

There are a number of fixes for FRV: a missing argument and a set of IRQ
patches from Thomas Gleixner.

David
---
The following changes since commit 4bbba111d94781d34081c37856bbc5eb33f6c72a:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-03-23 07:58:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-frv.git frv

Amerigo Wang (1):
      FRV: Do some cleanups

David Howells (2):
      NOMMU: percpu should use is_vmalloc_addr().
      FRV: Missing node arg in alloc_thread_info_node() macro

Graf Yang (1):
      NOMMU: support SMP dynamic percpu_alloc

Mike Frysinger (2):
      NOMMU: new vcoalesce helper function
      firmware loader: use vcoalesce for NOMMU

Thomas Gleixner (7):
      frv: Remove stale irq_chip.end
      frv: Fix typo from __do_IRQ overhaul
      frv: Convert mb93091 irq_chip to new functions
      frv: Convert mb93093 irq_chip to new function
      frv: Convert mb93493 irq_chip to new functions
      frv: Convert cpu irq_chip to new functions
      frv: Select GENERIC_HARDIRQS_NO_DEPRECATED

 arch/frv/Kconfig                   |    2 +-
 arch/frv/include/asm/system.h      |    9 ---------
 arch/frv/include/asm/thread_info.h |    4 +++-
 arch/frv/kernel/irq-mb93091.c      |   26 +++++++++++++-------------
 arch/frv/kernel/irq-mb93093.c      |   29 ++++++++++++++---------------
 arch/frv/kernel/irq-mb93493.c      |   22 +++++++++++-----------
 arch/frv/kernel/irq.c              |   35 +++++++++++++++--------------------
 drivers/base/firmware_class.c      |    2 +-
 include/linux/vmalloc.h            |   35 +++++++++++++++++++++++++++++++++++
 mm/nommu.c                         |   22 +++++++++++++++++++++-
 mm/percpu.c                        |    3 +--
 11 files changed, 115 insertions(+), 74 deletions(-)
