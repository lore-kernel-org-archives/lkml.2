Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1CIVLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:11:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab1CIVLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:11:41 -0500
Date: Wed, 9 Mar 2011 15:47:24 -0500
From: Jason Baron <jbaron@redhat.com>
To: peterz@infradead.org
Cc: hpa@zytor.com, mathieu.desnoyers@polymtl.ca, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1299702291.git.jbaron@redhat.com>
Subject: [PATCH 0/2] jump label: update for .39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Re-fresh of updates against latest -tip tree.

I've tried to split this update up somewhat, but I've only succeeded to split
out the dynamic debug bits. The interface changes and re-write are quite
intertwined.

I believe this update should address all the comments from the previous posting
except for Mathieu's request for a section of jump label pointers that point to
the jump label structures (since the compiler might leave gaps in the jump label
structures). I've got a prototype patch to address this issue but its somewhat
invasive, and thus I'd like to leave it as a follow-up item. I have to date,
not seen this issue in practice.

thanks,

-Jason


Jason Baron (2):
  jump label: introduce static_branch() interface
  dynamic debug: add jump label support

 arch/mips/include/asm/jump_label.h  |   22 +-
 arch/mips/kernel/jump_label.c       |    2 +-
 arch/sparc/include/asm/jump_label.h |   25 +-
 arch/x86/include/asm/alternative.h  |    3 +-
 arch/x86/include/asm/jump_label.h   |   26 +-
 arch/x86/kernel/alternative.c       |    2 +-
 arch/x86/kernel/jump_label.c        |    2 +-
 arch/x86/kernel/module.c            |    1 +
 include/asm-generic/vmlinux.lds.h   |   14 +-
 include/linux/dynamic_debug.h       |   44 +++-
 include/linux/jump_label.h          |   86 ++++---
 include/linux/jump_label_ref.h      |   44 ---
 include/linux/perf_event.h          |   26 +-
 include/linux/tracepoint.h          |   22 +-
 kernel/jump_label.c                 |  537 ++++++++++++++---------------------
 kernel/perf_event.c                 |    4 +-
 kernel/tracepoint.c                 |   23 +-
 lib/dynamic_debug.c                 |    4 +-
 18 files changed, 391 insertions(+), 496 deletions(-)
 delete mode 100644 include/linux/jump_label_ref.h

