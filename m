Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0J1N4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:56:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43419 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab0J1N4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:56:47 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=JQkcBDDvpVEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=ebugqXsTft_h8n6bOvQA:9 a=BK8XC5MkF5T25nHb65oRiyG4m2gA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101028135548.055490014@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Oct 2010 09:55:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/8] [GIT PULL] jump label: various fixes and updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/jump-label tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/jump-label


David Daney (2):
      jump label: Make arch_jump_label_text_poke_early() optional
      jump label: Add MIPS support.

David Miller (1):
      jump_label: Fix unaligned traps on sparc.

H. Peter Anvin (1):
      x86, ftrace: Use safe noops, drop trap test

Jason Baron (3):
      jump label: Fix module __init section race
      jump label: Fix deadlock b/w jump_label_mutex vs. text_mutex
      jump label: Disable due to compiler bug

Steven Rostedt (1):
      jump label: Fix error with preempt disable holding mutex

----
 arch/mips/Kconfig                   |    1 +
 arch/mips/include/asm/jump_label.h  |   48 ++++++++++++++++++++++++
 arch/mips/kernel/Makefile           |    3 +-
 arch/mips/kernel/jump_label.c       |   50 +++++++++++++++++++++++++
 arch/mips/kernel/module.c           |    5 ++
 arch/sparc/include/asm/jump_label.h |    2 +
 arch/x86/include/asm/jump_label.h   |    1 +
 arch/x86/kernel/alternative.c       |   69 +++++++---------------------------
 include/linux/jump_label.h          |   20 ++++++++++
 kernel/jump_label.c                 |   70 +++++++++++++++++++++++++++++-----
 kernel/kprobes.c                    |   26 ++++++++-----
 11 files changed, 219 insertions(+), 76 deletions(-)
