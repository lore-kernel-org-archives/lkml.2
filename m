Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1LEMFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:05:52 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46746 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab1LEMFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:05:50 -0500
X-AuditID: b753bd60-98d93ba000007b1b-7e-4edcb39cff81
X-AuditID: b753bd60-98d93ba000007b1b-7e-4edcb39cff81
Subject: [PATCH 1/6] [RESEND][BUGFIX] x86/tools: Fix Makefile to build all
 test tools
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 05 Dec 2011 21:05:33 +0900
Message-ID: <20111205120533.15475.62047.stgit@cloud>
In-Reply-To: <20111205120520.15475.82983.stgit@cloud>
References: <20111205120520.15475.82983.stgit@cloud>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arch/x86/tools/Makefile to compile both test tools
correctly. This bug leads build error.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/tools/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 3255c3d..d511aa9 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -25,8 +25,7 @@ posttest: $(obj)/test_get_len vmlinux $(obj)/insn_sanity
 	$(call cmd,posttest)
 	$(call cmd,sanitytest)
 
-hostprogs-y	:= test_get_len
-hostprogs-y	:= insn_sanity
+hostprogs-y	+= test_get_len insn_sanity
 
 # -I needed for generated C source and C source which in the kernel tree.
 HOSTCFLAGS_test_get_len.o := -Wall -I$(objtree)/arch/x86/lib/ -I$(srctree)/arch/x86/include/ -I$(srctree)/arch/x86/lib/ -I$(srctree)/include/

