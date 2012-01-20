Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2ATRmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:42:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56732 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2ATRmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:42:43 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW definition
Date: Fri, 20 Jan 2012 17:42:26 +0000
Message-Id: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.rc1.3.gb6310
X-OriginalArrivalTime: 20 Jan 2012 17:42:37.0287 (UTC) FILETIME=[E622AF70:01CCD79A]
X-MC-Unique: 112012017423904601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q0KHgppt006962

Hi,

This is version 3 of the set of patches removing
__ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM. The series was rebased on top of
3.3-rc1 and fixed the conflicts with the kernel/sched/ changes and the
ARM LPAE patches. There are no functional changes from v2. I plan to
push this to -next and get it ready for 3.4-rc1.

Question for Peter/Ingo - how do we merge the first patch that
introduces finish_arch_post_lock_switch? Do you pick it up or I can
merge it via rmk (with your ack)?

Thanks,

Catalin


Catalin Marinas (4):
  sched: Introduce the finish_arch_post_lock_switch() scheduler hook
  ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on ASID-capable CPUs
  ARM: Remove current_mm per-cpu variable
  ARM: Remove __ARCH_WANT_INTERRUPTS_ON_CTXSW on pre-ARMv6 CPUs

Will Deacon (2):
  ARM: Use TTBR1 instead of reserved context ID
  ARM: Allow ASID 0 to be allocated to tasks

 arch/arm/include/asm/mmu_context.h |  104 +++++++++++++++++++++++++++---------
 arch/arm/include/asm/system.h      |    7 ---
 arch/arm/include/asm/thread_info.h |    1 +
 arch/arm/mm/context.c              |   63 +++++++++++-----------
 arch/arm/mm/proc-v7-2level.S       |    9 +---
 kernel/sched/core.c                |    1 +
 kernel/sched/sched.h               |    3 +
 7 files changed, 117 insertions(+), 71 deletions(-)


