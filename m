Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2ECJCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:02:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:49875 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab2ECJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:48 -0400
Message-Id: <20120503083859.991965503@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch V2 00/31] init_task: Use a generic init_task variant
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures do roughly the same to initialize init_task. The
only architecture which deviates is ia64 as it allocates task_struct
and thread_info together.

Move the common code to init/init_task.c and remove all the redundant
copies.

Difference to V1:
	- FRV updates
	- left IA64 alone
	- Score/Sparc corrections
	- Picked up Acked-bys

Thanks,

        tglx

 arch/alpha/kernel/init_task.c           |   17 -------
 arch/arm/kernel/init_task.c             |   37 ----------------
 arch/avr32/kernel/init_task.c           |   31 --------------
 arch/blackfin/kernel/init_task.c        |   32 --------------
 arch/frv/kernel/init_task.c             |   32 --------------
 arch/h8300/kernel/init_task.c           |   36 ----------------
 arch/hexagon/kernel/init_task.c         |   54 ------------------------
 arch/m32r/kernel/init_task.c            |   34 ---------------
 arch/m68k/kernel/init_task.c            |   35 ----------------
 arch/microblaze/kernel/init_task.c      |   26 -----------
 arch/mips/kernel/init_task.c            |   35 ----------------
 arch/mn10300/kernel/init_task.c         |   39 -----------------
 arch/openrisc/kernel/init_task.c        |   42 -------------------
 arch/parisc/kernel/init_task.c          |   70 --------------------------------
 arch/powerpc/kernel/init_task.c         |   29 -------------
 arch/s390/kernel/init_task.c            |   38 -----------------
 arch/score/kernel/init_task.c           |   46 ---------------------
 arch/sh/kernel/init_task.c              |   30 -------------
 arch/sparc/kernel/init_task.c           |   22 ----------
 arch/tile/kernel/init_task.c            |   59 --------------------------
 arch/um/kernel/init_task.c              |   38 -----------------
 arch/unicore32/kernel/init_task.c       |   44 --------------------
 arch/x86/kernel/init_task.c             |   42 -------------------
 arch/xtensa/kernel/init_task.c          |   31 --------------
 tip/arch/Kconfig                        |    9 ++++
 tip/arch/alpha/kernel/Makefile          |    2 
 tip/arch/arm/Makefile                   |    2 
 tip/arch/arm/kernel/Makefile            |    2 
 tip/arch/avr32/kernel/Makefile          |    2 
 tip/arch/blackfin/Makefile              |    2 
 tip/arch/blackfin/kernel/Makefile       |    2 
 tip/arch/c6x/kernel/process.c           |   16 -------
 tip/arch/cris/kernel/process.c          |   28 ------------
 tip/arch/frv/Kconfig                    |    1 
 tip/arch/frv/Makefile                   |    2 
 tip/arch/frv/include/asm/thread_info.h  |    4 -
 tip/arch/frv/kernel/Makefile            |    2 
 tip/arch/frv/kernel/process.c           |   15 ------
 tip/arch/h8300/kernel/Makefile          |    2 
 tip/arch/hexagon/Makefile               |    3 -
 tip/arch/hexagon/kernel/Makefile        |    2 
 tip/arch/ia64/Kconfig                   |    3 +
 tip/arch/ia64/include/asm/thread_info.h |    3 -
 tip/arch/m32r/Makefile                  |    2 
 tip/arch/m32r/kernel/Makefile           |    2 
 tip/arch/m68k/kernel/Makefile           |    2 
 tip/arch/microblaze/kernel/Makefile     |    2 
 tip/arch/mips/Makefile                  |    2 
 tip/arch/mips/kernel/Makefile           |    2 
 tip/arch/mips/kernel/vmlinux.lds.S      |    2 
 tip/arch/mn10300/Makefile               |    2 
 tip/arch/mn10300/kernel/Makefile        |    2 
 tip/arch/openrisc/Makefile              |    2 
 tip/arch/openrisc/kernel/Makefile       |    2 
 tip/arch/parisc/mm/init.c               |   12 +++++
 tip/arch/powerpc/kernel/Makefile        |    2 
 tip/arch/s390/Makefile                  |    1 
 tip/arch/s390/kernel/Makefile           |    2 
 tip/arch/score/kernel/Makefile          |    2 
 tip/arch/sh/Makefile                    |    2 
 tip/arch/sh/kernel/Makefile             |    2 
 tip/arch/sparc/Makefile                 |    1 
 tip/arch/sparc/kernel/Makefile          |    1 
 tip/arch/tile/kernel/Makefile           |    2 
 tip/arch/tile/kernel/setup.c            |   16 +++++++
 tip/arch/um/kernel/Makefile             |    2 
 tip/arch/um/kernel/um_arch.c            |    5 ++
 tip/arch/unicore32/Makefile             |    1 
 tip/arch/unicore32/kernel/Makefile      |    2 
 tip/arch/x86/Makefile                   |    1 
 tip/arch/x86/kernel/Makefile            |    2 
 tip/arch/x86/kernel/process.c           |    9 ++++
 tip/arch/xtensa/kernel/Makefile         |    2 
 tip/init/Makefile                       |    4 +
 tip/init/init_task.c                    |   24 ++++++++++
 tip/kernel/fork.c                       |    6 +-
 tip/kernel/sched/Makefile               |    2 
 77 files changed, 117 insertions(+), 1009 deletions(-)


