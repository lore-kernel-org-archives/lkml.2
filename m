Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2KZLEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:04:52 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34531 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2KZLEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:04:51 -0500
Subject: [PATCH 0/2] uprobes/powerpc: Replace ptrace single step helpers
To: bigeasy@linutronix.de, oleg@redhat.com, ananth@in.ibm.com,
        srikar@linux.vnet.ibm.com
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 16:34:43 +0530
Message-ID: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12112611-9574-0000-0000-0000057E2AC5
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

---

Suzuki K. Poulose (2):
      powerpc: Move the single step enable code to a generic path
      uprobes/powerpc: Make use of generic routines to enable single step


 arch/powerpc/include/asm/probes.h  |   29 +++++++++++++++++++++++++++++
 arch/powerpc/include/asm/uprobes.h |    4 ++++
 arch/powerpc/kernel/kprobes.c      |   21 +--------------------
 arch/powerpc/kernel/uprobes.c      |   11 +++++++++--
 4 files changed, 43 insertions(+), 22 deletions(-)

-- 
Suzuki

