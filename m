Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2EEPFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 11:05:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:33113 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab2EEPFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 11:05:41 -0400
Message-Id: <20120505150007.543515803@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 May 2012 15:05:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 00/18] fork: Move most archs to generic threadinfo/taskstruct
 allocators
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a lot of duplicate implementations of the threadinfo and task
struct allocator around in arch/*. This series consolidates them.

Applies on top of 

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git smp/hotplug

Thanks,

	tglx
---
 arch/Kconfig                            |    8 +++
 arch/c6x/include/asm/thread_info.h      |   17 -------
 arch/cris/include/asm/processor.h       |    5 --
 arch/cris/include/asm/thread_info.h     |    6 --
 arch/frv/include/asm/thread_info.h      |   13 ------
 arch/hexagon/include/asm/thread_info.h  |    8 ---
 arch/hexagon/kernel/process.c           |   37 -----------------
 arch/ia64/Kconfig                       |    2 
 arch/ia64/include/asm/thread_info.h     |    3 -
 arch/m32r/include/asm/thread_info.h     |   17 -------
 arch/mips/include/asm/thread_info.h     |   12 -----
 arch/mn10300/include/asm/thread_info.h  |   17 +------
 arch/mn10300/kernel/kgdb.c              |    3 -
 arch/powerpc/include/asm/thread_info.h  |   13 ------
 arch/powerpc/kernel/process.c           |   31 --------------
 arch/score/include/asm/thread_info.h    |   10 +---
 arch/sh/include/asm/thread_info.h       |   11 -----
 arch/sh/kernel/process.c                |   46 ---------------------
 arch/sparc/Kconfig                      |    1 
 arch/sparc/include/asm/thread_info_32.h |    2 
 arch/sparc/include/asm/thread_info_64.h |   25 -----------
 arch/tile/include/asm/thread_info.h     |    6 --
 arch/tile/kernel/process.c              |   23 ----------
 arch/x86/include/asm/boot.h             |    2 
 arch/x86/include/asm/page_32_types.h    |    4 -
 arch/x86/include/asm/page_64_types.h    |    4 -
 arch/x86/include/asm/thread_info.h      |   21 ---------
 arch/x86/kernel/irq_32.c                |    8 +--
 arch/x86/kernel/process.c               |    5 --
 include/linux/thread_info.h             |    6 ++
 kernel/fork.c                           |   69 ++++++++++++++++++++++----------
 31 files changed, 100 insertions(+), 335 deletions(-)



