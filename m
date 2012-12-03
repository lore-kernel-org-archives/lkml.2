Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab2LCPHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:07:25 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:59010 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2LCPHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:07:23 -0500
Subject: [PATCH v2 0/4] uprobes/powerpc: Replace ptrace helpers for single
 stepping
To: bigeasy@linutronix.de, oleg@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 20:37:08 +0530
Message-ID: <20121203150438.7727.74924.stgit@suzukikp>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120315-8256-0000-0000-000005477583
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series replaces the ptrace helpers used for single step
enable/disable for uprobes on powerpc, with uprobe specific code.

We reuse the kprobe code to enable single stepping by making it generic
and save/restore the MSR (and DBCR for BookE) across the single step.

This series applies on top of the patches posted by Oleg at :
	https://lkml.org/lkml/2012/10/28/92 


Patches have been verified on Power6 and PPC440 (BookE).

Changes since V1: 

 * Don't disable external interrupts. (Sebastian)
 * Introduced routines for saving/restoring the context for sstep.
 * Restore the context in arch_uprobe_abort_xol() (Oleg)


---

Suzuki K. Poulose (4):
      kprobes/powerpc: Do not disable External interrupts during single step
      powerpc: Move the single step enable code to a generic path
      uprobes/powerpc: Introduce routines for save/restore context
      uprobes/powerpc: Make use of generic routines to enable single step


 arch/powerpc/include/asm/probes.h  |   25 +++++++++++++++++++++++++
 arch/powerpc/include/asm/uprobes.h |    4 ++++
 arch/powerpc/kernel/kprobes.c      |   21 +--------------------
 arch/powerpc/kernel/uprobes.c      |   32 +++++++++++++++++++++++++-------
 4 files changed, 55 insertions(+), 27 deletions(-)

-- 
Suzuki

