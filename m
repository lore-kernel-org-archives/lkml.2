Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1CPT7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:59:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab1CPT7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:59:13 -0400
Date: Wed, 16 Mar 2011 15:58:14 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        ralf@linux-mips.org, jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1300299760.git.jbaron@redhat.com>
Subject: [PATCH v2 0/4] jump label: update for .39 v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Update against tip/perf/urgent. I've incorporated feedback from the last round.
Hopefully these can still be considered for .39.

thanks,

-Jason

v2:
  -add initial s390 support
  -add jump section alignment for x86
  -add types.h and compiler.h to jump_label.h
  -moved jump_label_sort_entries() into jump_label_add_module()

Jan Glauber (1):
  jump label: add s390 support

Jason Baron (3):
  jump label: introduce static_branch() interface
  dynamic debug: add jump label support
  jump label: add _ASM_ALIGN for x86 and x86_64

 arch/mips/include/asm/jump_label.h  |   22 +-
 arch/s390/Kconfig                   |    1 +
 arch/s390/include/asm/jump_label.h  |   37 +++
 arch/s390/kernel/Makefile           |    2 +-
 arch/s390/kernel/jump_label.c       |   59 ++++
 arch/sparc/include/asm/jump_label.h |   25 +-
 arch/x86/include/asm/alternative.h  |    3 +-
 arch/x86/include/asm/jump_label.h   |   27 +-
 arch/x86/kernel/alternative.c       |    2 +-
 arch/x86/kernel/module.c            |    1 +
 include/asm-generic/vmlinux.lds.h   |   14 +-
 include/linux/dynamic_debug.h       |   44 +++-
 include/linux/jump_label.h          |   89 ++++---
 include/linux/jump_label_ref.h      |   44 ---
 include/linux/perf_event.h          |   26 +-
 include/linux/tracepoint.h          |   22 +-
 kernel/jump_label.c                 |  539 ++++++++++++++---------------------
 kernel/perf_event.c                 |    4 +-
 kernel/tracepoint.c                 |   23 +-
 lib/dynamic_debug.c                 |    4 +-
 20 files changed, 494 insertions(+), 494 deletions(-)
 create mode 100644 arch/s390/include/asm/jump_label.h
 create mode 100644 arch/s390/kernel/jump_label.c
 delete mode 100644 include/linux/jump_label_ref.h

