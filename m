Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2APJCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:02:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab2APJCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:02:34 -0500
Date: Mon, 16 Jan 2012 01:02:17 -0800
From: tip-bot for Ulrich Drepper <drepper@gmail.com>
Message-ID: <tip-8d973b624ece3b85cfae9474935795d034f72faf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        drepper@gmail.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <CAOPLpQfytPyDEBF1Hbkpo7ovUerEsstVGxBr=EpDL-BKEMaqLA@mail.gmail.com>
References: <CAOPLpQfytPyDEBF1Hbkpo7ovUerEsstVGxBr=EpDL-BKEMaqLA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/kprobes:
  Fix typo transferred from Intel manual
Git-Commit-ID: 8d973b624ece3b85cfae9474935795d034f72faf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Jan 2012 01:02:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d973b624ece3b85cfae9474935795d034f72faf
Gitweb:     http://git.kernel.org/tip/8d973b624ece3b85cfae9474935795d034f72faf
Author:     Ulrich Drepper <drepper@gmail.com>
AuthorDate: Sun, 15 Jan 2012 19:40:24 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Jan 2012 08:20:36 +0100

x86/kprobes: Fix typo transferred from Intel manual

The arch/x86/lib/x86-opcode-map.txt file [used by the
kprobes instruction decoder] contains the line:

  af: SCAS/W/D/Q rAX,Xv

This is what the Intel manuals show, but it's not correct.
The 'X' stands for:

  Memory addressed by the DS:rSI register pair (for example, MOVS, CMPS, OUTS, or LODS).

On the other hand 'Y' means (also see the ae byte entry for
SCASB):

  Memory addressed by the ES:rDI register pair (for example, MOVS, CMPS, INS, STOS, or SCAS).

Signed-off-by: Ulrich Drepper <drepper@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/CAOPLpQfytPyDEBF1Hbkpo7ovUerEsstVGxBr%3DEpDL-BKEMaqLA@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/x86-opcode-map.txt |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index a793da5..8641bbb 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -210,7 +210,9 @@ ab: STOS/W/D/Q Yv,rAX
 ac: LODS/B AL,Xb
 ad: LODS/W/D/Q rAX,Xv
 ae: SCAS/B AL,Yb
-af: SCAS/W/D/Q rAX,Xv
+# Note: The May 2011 Intel manual shows Xv for the second parameter of the
+# next instruction but Yv is correct
+af: SCAS/W/D/Q rAX,Yv
 # 0xb0 - 0xbf
 b0: MOV AL/R8L,Ib
 b1: MOV CL/R9L,Ib
