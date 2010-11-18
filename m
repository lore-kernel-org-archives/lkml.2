Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab0KROOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:14:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:52278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849Ab0KROOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:14:46 -0500
Date: Thu, 18 Nov 2010 14:14:11 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101118101655.2779.2816.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101118101655.2779.2816.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] x86/kprobes: Prevent kprobes to probe on save_args()
Message-ID: <tip-de31ec8a31046111befd16a7083e3bdda2ff42cf@git.kernel.org>
Git-Commit-ID: de31ec8a31046111befd16a7083e3bdda2ff42cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:14:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de31ec8a31046111befd16a7083e3bdda2ff42cf
Gitweb:     http://git.kernel.org/tip/de31ec8a31046111befd16a7083e3bdda2ff42cf
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 18 Nov 2010 19:16:55 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:40:19 +0100

x86/kprobes: Prevent kprobes to probe on save_args()

Prevent kprobes to probe on save_args() since this function
will be called from breakpoint exception handler. That will
cause infinit loop on breakpoint handling.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20101118101655.2779.2816.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index fe2690d..e3ba417 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -295,6 +295,7 @@ ENDPROC(native_usergs_sysret64)
 	.endm
 
 /* save partial stack frame */
+	.pushsection .kprobes.text, "ax"
 ENTRY(save_args)
 	XCPT_FRAME
 	cld
@@ -334,6 +335,7 @@ ENTRY(save_args)
 	ret
 	CFI_ENDPROC
 END(save_args)
+	.popsection
 
 ENTRY(save_rest)
 	PARTIAL_FRAME 1 REST_SKIP+8
