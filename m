Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0JNHmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:42:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:37711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0JNHmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:42:10 -0400
Date: Thu, 14 Oct 2010 07:41:28 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        mathieu.desnoyers@efficios.com, rusty@rustcorp.com.au,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014031042.4100.90877.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031042.4100.90877.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kconfig/x86: Add HAVE_TEXT_POKE_SMP config for stop_machine dependency
Message-ID: <tip-3cba11d32bb4b24c3ba257043595772df4b9c7b5@git.kernel.org>
Git-Commit-ID: 3cba11d32bb4b24c3ba257043595772df4b9c7b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 07:41:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cba11d32bb4b24c3ba257043595772df4b9c7b5
Gitweb:     http://git.kernel.org/tip/3cba11d32bb4b24c3ba257043595772df4b9c7b5
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Oct 2010 12:10:42 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 08:55:29 +0200

kconfig/x86: Add HAVE_TEXT_POKE_SMP config for stop_machine dependency

Since the text_poke_smp() definately depends on actual
stop_machine() on smp, add that dependency to Kconfig.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
LKML-Reference: <20101014031042.4100.90877.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b431a08..c14d8b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -60,6 +60,7 @@ config X86
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_TEXT_POKE_SMP
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -2126,6 +2127,10 @@ config HAVE_ATOMIC_IOMAP
 	def_bool y
 	depends on X86_32
 
+config HAVE_TEXT_POKE_SMP
+	bool
+	select STOP_MACHINE if SMP
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
