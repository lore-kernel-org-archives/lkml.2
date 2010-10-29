Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574Ab0J2TBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:01:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759050Ab0J2TBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:01:36 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=ltcHvnG3qaUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=k8r0MZpiDIVie2nz5pcA:9 a=6HArHSLKa3Giq2yULJ6oDXH6djgA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029190050.674141729@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 15:00:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL] jump label: fixes and work arounds
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/jump-label-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/jump-label-2


David Miller (1):
      jump_label: Fix unaligned traps on sparc.

H. Peter Anvin (1):
      x86, ftrace: Use safe noops, drop trap test

Jason Baron (2):
      jump label: Fix module __init section race
      jump label: Fix deadlock b/w jump_label_mutex vs. text_mutex

Steven Rostedt (3):
      jump label: Fix error with preempt disable holding mutex
      jump label: Make arch_jump_label_text_poke_early() optional
      jump label: Add work around to i386 gcc asm goto bug

----
 arch/Kconfig                        |   14 ++++++
 arch/sparc/include/asm/jump_label.h |    1 +
 arch/x86/Makefile_32.cpu            |   13 +++++-
 arch/x86/kernel/alternative.c       |   69 +++++++------------------------
 include/linux/jump_label.h          |    7 +++-
 kernel/jump_label.c                 |   77 ++++++++++++++++++++++++++++++-----
 kernel/kprobes.c                    |   26 +++++++-----
 7 files changed, 130 insertions(+), 77 deletions(-)
