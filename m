Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3AILZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:25:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379Ab3AILZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:25:20 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH v2 0/4] uprobes: return probe implementation
Date: Wed,  9 Jan 2013 12:24:48 +0100
Message-Id: <1357730692-3928-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are RFC uretprobes implementation. I'd be grateful for review.

  RFCv1: https://lkml.org/lkml/2012/12/21/133

I've intentionally removed the retprobe bypass logic, it requires 
a bit more work.

not fixed since last prior RFC review:
  unify xol_get_trampoline_slot() and xol_take_insn_slot()
  protect uprobe in prepare_uretprobe()

v2 changes:
  introduced rp_handler(), get rid of return_consumers
  get rid of uretprobe_[un]register()
  introduced arch_uretprobe_get_sp()
  removed uprobe_task->doomed, kill task immediately
  fix arch_uretprobe_hijack_return_addr()'s returns
  address the v1 minor issues

thanks,

Anton Arapov (5):
  uretprobes/x86: hijack return address
  uretprobes: trampoline implementation
  uretprobes: return probe entry, prepare uretprobe
  uretprobes: invoke return probe handlers

 arch/x86/include/asm/uprobes.h |   6 ++
 arch/x86/kernel/uprobes.c      |  48 +++++++++++
 include/linux/uprobes.h        |   9 ++
 kernel/events/uprobes.c        | 181 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 241 insertions(+), 3 deletions(-)

-- 
1.8.0.2

