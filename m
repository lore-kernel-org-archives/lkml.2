Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2FDJ6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:58:47 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:43983 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2FDJ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:58:41 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: owasserm@redhat.com, quintela@redhat.com, avi@redhat.com,
        pbonzini@redhat.com, aliguori@us.ibm.com, stefanha@gmail.com,
        dlaor@redhat.com, mdroth@linux.vnet.ibm.com,
        yoshikawa.takuya@oss.ntt.co.jp, benoit.hudzia@gmail.com,
        aarcange@redhat.com, t.hirofuchi@aist.go.jp, satoshi.itoh@aist.go.jp
Subject: [PATCH v3 0/2]  postcopy migration: umem: Linux char device for postcopy
Date: Mon,  4 Jun 2012 18:58:38 +0900
Message-Id: <cover.1338803423.git.yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is Linux kernel driver for qemu/kvm postcopy live migration.
This is used by qemu/kvm postcopy live migration patch.

TODO:
- Consider FUSE/CUSE option
  So far several mmap patches for FUSE/CUSE are floating around. (their
  purpose isn't different from our purpose, though). They haven't merged
  into the upstream yet.
  The driver specific part in qemu patches is modularized. So I expect it
  wouldn't be difficult to switch kernel driver to CUSE based driver.

ioctl commands:
UMEM_INIT: initialize umem device for qemu
UMEM_MAKE_VMA_ANONYMOUS: make the specified vma in the qemu process
                         This is _NOT_ implemented yet.
                         anonymous I'm not sure whether this can be implemented
                         or not.
---
Changes v2 -> v3:
- make fault handler killable
- make use of read()/write()
- documentation

Changes version 1 -> 2:
- make ioctl structures padded to align
- un-KVM
  KVM_VMEM -> UMEM
- dropped some ioctl commands as Avi requested

Isaku Yamahata (2):
  export necessary symbols
  umem: chardevice for kvm postcopy

 Documentation/misc-devices/umem.txt |  303 ++++++++++++
 drivers/char/Kconfig                |   10 +
 drivers/char/Makefile               |    1 +
 drivers/char/umem.c                 |  900 +++++++++++++++++++++++++++++++++++
 include/linux/umem.h                |   42 ++
 mm/memcontrol.c                     |    1 +
 mm/mempolicy.c                      |    1 +
 mm/shmem.c                          |    1 +
 8 files changed, 1259 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/umem.txt
 create mode 100644 drivers/char/umem.c
 create mode 100644 include/linux/umem.h

