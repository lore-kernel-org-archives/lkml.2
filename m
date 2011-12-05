Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1LERlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:41:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab1LERla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:41:30 -0500
Date: Mon, 5 Dec 2011 09:41:15 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-1056c3e916f12cdd8042ab27dfccbb3a9e871df0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111205120533.15475.62047.stgit@cloud>
References: <20111205120533.15475.62047.stgit@cloud>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/tools: Fix Makefile to build all test tools
Git-Commit-ID: 1056c3e916f12cdd8042ab27dfccbb3a9e871df0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:41:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1056c3e916f12cdd8042ab27dfccbb3a9e871df0
Gitweb:     http://git.kernel.org/tip/1056c3e916f12cdd8042ab27dfccbb3a9e871df0
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 5 Dec 2011 21:05:33 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 14:53:13 +0100

x86/tools: Fix Makefile to build all test tools

Fix arch/x86/tools/Makefile to compile both test tools
correctly. This bug leads build error.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20111205120533.15475.62047.stgit@cloud
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
