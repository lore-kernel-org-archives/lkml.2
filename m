Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0FXVlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:41:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0FXVk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=b3vHAs1yiGFRnPkYhxnI9TaG96KVSwOdpnQRgkqazYNCMK/mRFv26doQZVQ2irACWm
         sAkMAriUPQIZyAf6RlvsV7SyglxyFiAcvk41+1j7g7u3LbbEfCalROUI0So1FXpQw60t
         lKWft3TIs+ylnSL8CEHjNDBfW/mi8cK71V4M0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/7] perf: Fix argument of perf_arch_fetch_caller_regs
Date: Thu, 24 Jun 2010 23:40:53 +0200
Message-Id: <1277415658-10036-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

"struct regs" was set to argument of perf_arch_fetch_caller_regs
off-case. It should be "struct pt_regs".

This fixes various build errors in archs that have CONFIG_PERF_EVENTS=y
but no overriden implementation of perf_arch_fetch_caller_regs.

cc1: warnings being treated as errors
In file included from include/linux/ftrace_event.h:8,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:75,
                 from arch/sh/kernel/sys_sh32.c:9:
include/linux/perf_event.h:937: error: 'struct regs' declared inside parameter list
include/linux/perf_event.h:937: error: its scope is only this definition or declaration, which is probably not what you want
include/linux/perf_event.h: In function 'perf_fetch_caller_regs':
include/linux/perf_event.h:952: error: passing argument 1 of 'perf_arch_fetch_caller_regs' from incompatible pointer type

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0dd5f8a..937495c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -936,7 +936,7 @@ extern void __perf_sw_event(u32, u64, int, struct pt_regs *, u64);
 
 #ifndef perf_arch_fetch_caller_regs
 static inline void
-perf_arch_fetch_caller_regs(struct regs *regs, unsigned long ip) { }
+perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
 #endif
 
 /*
-- 
1.6.2.3

