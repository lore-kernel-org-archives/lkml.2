Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab1GLH6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:58:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53085 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1GLH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:58:22 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org
Subject: [PATCHSET x86/mm] memblock, x86: Misc cleanups
Date: Tue, 12 Jul 2011 09:58:04 +0200
Message-Id: <1310457490-3356-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following six cleanup patches in generic
and x86 memblock code paths.  All the changes in this function are
more or less trivial.  This prepares for further memblock updates.

 0001-x86-Fix-memblock_x86_check_reserved_size-use-in-efi_.patch
 0002-bootmem-Fix-__free_pages_bootmem-to-use-order-proper.patch
 0003-memblock-Use-MEMBLOCK_ALLOC_ACCESSIBLE-instead-of-AN.patch
 0004-memblock-Use-round_up-down-instead-of-memblock_align.patch
 0005-memblock-Kill-MEMBLOCK_ERROR.patch
 0006-memblock-Replace-memblock_find_base-with-memblock_fi.patch

This patchset is on top of

  x86/urgent (5da0ef9a85 "x86: Disable AMD_NUMA for 32bit for now")
+ pfn->nid granularity check patches [1]

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-x86-mm-prep

diffstat follows.

 arch/x86/kernel/aperture_64.c |    2 -
 arch/x86/kernel/check.c       |    2 -
 arch/x86/kernel/e820.c        |    2 -
 arch/x86/kernel/setup.c       |    4 +-
 arch/x86/kernel/trampoline.c  |    2 -
 arch/x86/mm/init.c            |    2 -
 arch/x86/mm/memblock.c        |    6 ++--
 arch/x86/mm/numa.c            |    6 ++--
 arch/x86/mm/numa_32.c         |    4 +-
 arch/x86/mm/numa_emulation.c  |    2 -
 arch/x86/platform/efi/efi.c   |    3 --
 include/linux/memblock.h      |    7 ++--
 kernel/printk.c               |    2 -
 mm/memblock.c                 |   63 +++++++++++++++---------------------------
 mm/nobootmem.c                |    2 -
 mm/page_alloc.c               |    8 ++---
 16 files changed, 49 insertions(+), 68 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1166521
