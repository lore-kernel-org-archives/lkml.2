Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0KRKUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:20:37 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40806 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0KRKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:20:36 -0500
X-AuditID: b753bd60-a73a6ba000003e7d-ef-4ce4fdf1e766
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip ] [BUGFIX] x86/kprobes: Prevent kprobes to probe on
	save_args
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Nov 2010 19:16:55 +0900
Message-ID: <20101118101655.2779.2816.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent kprobes to probe on save_args() since this function
will be called from breakpoint exception handler. That will
cause infinit loop on breakpoint handling.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
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

