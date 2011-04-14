Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab1DNGBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:01:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57533 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab1DNGBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:01:36 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/5] ptrace low level unification
Date: Thu, 14 Apr 2011 02:01:30 -0400
Message-Id: <1302760895-13459-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of low level ptrace unification steps to make it easier
for common code (like KGDB) to poke at register state.  This also avoids
having to duplicate higher level operations for most ports which don't
have special needs for accessing things.

Mike Frysinger (5):
  asm-generic/ptrace.h: start a common low level ptrace helper
  Blackfin: convert to asm-generic ptrace.h
  x86: convert to asm-generic ptrace.h
  sh: convert to asm-generic ptrace.h
  kgdbts: unify/generalize gdb breakpoint adjustment

 arch/blackfin/include/asm/kgdb.h   |    1 +
 arch/blackfin/include/asm/ptrace.h |    5 +-
 arch/sh/include/asm/kgdb.h         |    1 +
 arch/sh/include/asm/ptrace.h       |    6 ++-
 arch/x86/include/asm/kgdb.h        |    1 +
 arch/x86/include/asm/ptrace.h      |   18 ++------
 drivers/misc/kgdbts.c              |   29 +++++---------
 include/asm-generic/ptrace.h       |   74 ++++++++++++++++++++++++++++++++++++
 8 files changed, 99 insertions(+), 36 deletions(-)
 create mode 100644 include/asm-generic/ptrace.h

-- 
1.7.5.rc1

