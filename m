Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1C2OD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:03:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab1C2ODZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:03:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, tglx@linutronix.de, amwang@redhat.com,
        vapier@gentoo.org, lethal@linux-sh.org
Subject: [GIT PULL] NOMMU and FRV patches [ver #2]
Date: Tue, 29 Mar 2011 15:02:38 +0100
Message-ID: <1090.1301407358@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you pull these patches please?

There are a number of fixes for NOMMU: fixes to deal with breakage due to
MMU-mode changes.  I've dropped the vcoalesce() patches for the moment.

There are a number of fixes for FRV: a missing argument and a set of IRQ
patches from Thomas Gleixner.

The patches compile and run on FRV (NOMMU) and x86_64.

David
---
The following changes since commit 16c29dafcc86024048f1dbb8349d31cb22c7c55a:

  Merge branch 'syscore' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-03-25 21:07:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-frv.git frv

Amerigo Wang (1):
      FRV: Do some cleanups

David Howells (2):
      NOMMU: percpu should use is_vmalloc_addr().
      FRV: Missing node arg in alloc_thread_info_node() macro

Graf Yang (1):
      NOMMU: support SMP dynamic percpu_alloc

Mike Frysinger (1):
      NOMMU: implement access_remote_vm

Thomas Gleixner (9):
      frv: Remove stale irq_chip.end
      frv: Fix typo from __do_IRQ overhaul
      frv: Convert mb93091 irq_chip to new functions
      frv: Convert mb93093 irq_chip to new function
      frv: Convert mb93493 irq_chip to new functions
      frv: Convert cpu irq_chip to new functions
      frv: Select GENERIC_HARDIRQS_NO_DEPRECATED
      FRV: Convert genirq namespace
      FRV: Use generic show_interrupts()

 arch/frv/Kconfig                   |    3 +-
 arch/frv/include/asm/system.h      |    9 ----
 arch/frv/include/asm/thread_info.h |    4 +-
 arch/frv/kernel/irq-mb93091.c      |   30 +++++++-------
 arch/frv/kernel/irq-mb93093.c      |   31 +++++++-------
 arch/frv/kernel/irq-mb93493.c      |   25 ++++++-----
 arch/frv/kernel/irq.c              |   80 ++++++++----------------------------
 include/linux/vmalloc.h            |   32 ++++++++++++++
 mm/nommu.c                         |   52 +++++++++++++++++------
 mm/percpu.c                        |    3 +-
 10 files changed, 138 insertions(+), 131 deletions(-)
