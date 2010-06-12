Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0FLSpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 14:45:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42698 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab0FLSpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 14:45:16 -0400
From: Himanshu Chauhan <hschauhan@nulltrace.org>
To: linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org
Subject: [PATCH][UPDATED] MIPS: Kprobe support v0.2
Date: Sat, 12 Jun 2010 21:50:55 +0530
Message-Id: <1276359656-2375-1-git-send-email-hschauhan@nulltrace.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276359441-1846-1-git-send-email-hschauhan@nulltrace.org>
References: <1276359441-1846-1-git-send-email-hschauhan@nulltrace.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updated version of patch incorporates some of the comments
from Daney. The list of changes are as follows:
o Instead of separate handler "do_break", do_bp is used to
  track and handle kprobe induced breaks. This cleans up ugly
  ifdef hack.
o Instead of using 0 and 5 code in break, new kprobe specific
  defines (515, 516) have been added and handled.

The use of notify_die could not be dropped because the kprobes
framework installs handlers on notify_die chain.

Himanshu Chauhan (1):
  MIPS: Kprobe support v0.2     This incorporates some of the comments
    from Daney.

 arch/mips/Kconfig               |   13 ++
 arch/mips/include/asm/break.h   |    2 +
 arch/mips/include/asm/kdebug.h  |    5 +
 arch/mips/include/asm/kprobes.h |   86 +++++++++
 arch/mips/kernel/Makefile       |    2 +
 arch/mips/kernel/kprobes.c      |  379 +++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c        |   46 +++++-
 arch/mips/mm/fault.c            |   11 +-
 8 files changed, 541 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/include/asm/kprobes.h
 create mode 100644 arch/mips/kernel/kprobes.c

