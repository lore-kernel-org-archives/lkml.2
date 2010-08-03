Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab0HCSWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:22:40 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19446 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392Ab0HCSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:22:38 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org, hschauhan@nulltrace.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 0/5] KProbes support for MIPS
Date: Tue,  3 Aug 2010 11:22:17 -0700
Message-Id: <1280859742-26364-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
X-OriginalArrivalTime: 03 Aug 2010 18:22:36.0641 (UTC) FILETIME=[D942CD10:01CB3338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds KProbs, JProbs and KRetProbes support for the MIPS
archetecture.

It was tested on a 64-bit big-endian kernel (Octeon), but should work
equally well on 32-bit and little-endian as well.

As you can see from the patches it is partially based on previous work
by Sony and Himanshu Chauhan.

David Daney (5):
  MIPS: Define regs_return_value()
  MIPS: Add instrunction format for BREAK and SYSCALL
  MIPS: Add KProbe support.
  samples: kprobe_example: Make it print something on MIPS.
  documentation: Mention that KProbes is supported on MIPS

 Documentation/kprobes.txt        |    1 +
 arch/mips/Kconfig                |    2 +
 arch/mips/Makefile               |    3 +
 arch/mips/include/asm/break.h    |    2 +
 arch/mips/include/asm/inst.h     |   15 +-
 arch/mips/include/asm/kdebug.h   |    3 +
 arch/mips/include/asm/kprobes.h  |   91 ++++++
 arch/mips/include/asm/ptrace.h   |    1 +
 arch/mips/kernel/Makefile        |    1 +
 arch/mips/kernel/kprobes.c       |  562 ++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c         |   22 ++-
 arch/mips/mm/fault.c             |   15 +-
 samples/kprobes/kprobe_example.c |    9 +
 13 files changed, 724 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/include/asm/kprobes.h
 create mode 100644 arch/mips/kernel/kprobes.c

