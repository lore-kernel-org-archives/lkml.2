Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab1KUJIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:08:00 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35988 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab1KUJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:07:55 -0500
X-AuditID: b753bd60-9ea82ba000000655-e0-4eca14e974ba
X-AuditID: b753bd60-9ea82ba000000655-e0-4eca14e974ba
Subject: [PATCH 1/4] [BUGFIX] x86/tools: Fix Makefile to build all test tools
To: Ingo Molnar <mingo@elte.hu>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Tue, 22 Nov 2011 03:11:01 +0900
Message-ID: <20111121181101.27410.24906.stgit@cloud>
In-Reply-To: <20111121181044.27410.263.stgit@cloud>
References: <20111121181044.27410.263.stgit@cloud>
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

