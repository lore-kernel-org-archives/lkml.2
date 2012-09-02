Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2IBVdC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:33:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46129 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2IBVdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:00 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/7] x86: fix sparse warnings
Date: Sun,  2 Sep 2012 23:31:39 +0200
Message-Id: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes sparse warnings below arch/x86/ -- mostly address space
related, e.g. missing __user or __iomem annotations. Also minor C style
issues were fixed (duplicated const keyword; 0 instead of NULL).

All of these make spare complain less for code in arch/x86/.

Please apply!

Regards,

Mathias Krause (7):
  x86: fix __user annotations in asm/sys_ia32.h
  x86, vdso: add __user annotation to VDSO32_SYMBOL
  x86: ia32_signal.c: add __user casts to fix sparse warnings
  x86, probe_roms: add missing __iomem annotation to pci_map_biosrom()
  x86, xsave: keep __user annotation in casts
  x86, iommu: drop duplicate const in __IOMMU_INIT
  x86, iommu: use NULL instead of plain 0 for __IOMMU_INIT

 arch/x86/ia32/ia32_signal.c        |   11 ++++++-----
 arch/x86/ia32/sys_ia32.c           |    2 +-
 arch/x86/include/asm/iommu_table.h |    6 +++---
 arch/x86/include/asm/sys_ia32.h    |    2 +-
 arch/x86/include/asm/vdso.h        |    3 ++-
 arch/x86/kernel/probe_roms.c       |    2 +-
 arch/x86/kernel/xsave.c            |    6 +++---
 7 files changed, 17 insertions(+), 15 deletions(-)

-- 
1.7.10.4

