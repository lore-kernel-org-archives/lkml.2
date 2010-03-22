Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0CVQHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:07:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab0CVQHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:07:47 -0400
Date: Mon, 22 Mar 2010 12:07:14 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com
Message-Id: <cover.1269272444.git.jbaron@redhat.com>
Subject: [PATCH 0/5] jump label v5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Refresh of jump labeling patches aginst latest -tip tree. For bacground see:
 see previous posting: http://marc.info/?l=linux-kernel&m=125858436505941&w=2

The biggest change is dropping Masami's 'text_poke_smp()' since its now
in the -tip tree.

thanks,

-Jason

Jason Baron (4):
  jump label: base patch
  jump label: x86 support
  jump label: tracepoint support
  jump label: add module support

Mathieu Desnoyers (1):
  jump label: notifier atomic call chain notrace

 arch/x86/include/asm/jump_label.h |   31 ++++
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/jump_label.c      |   53 +++++++
 arch/x86/kernel/ptrace.c          |    1 +
 include/asm-generic/vmlinux.lds.h |   10 +-
 include/linux/jump_label.h        |   58 +++++++
 include/linux/module.h            |    5 +-
 include/linux/tracepoint.h        |   34 +++--
 kernel/Makefile                   |    2 +-
 kernel/jump_label.c               |  301 +++++++++++++++++++++++++++++++++++++
 kernel/module.c                   |    7 +
 kernel/notifier.c                 |    6 +-
 kernel/tracepoint.c               |    8 +
 13 files changed, 496 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h
 create mode 100644 kernel/jump_label.c

