Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0FYN0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 09:26:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:42455 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755863Ab0FYN0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 09:26:37 -0400
Date: Fri, 25 Jun 2010 13:25:58 GMT
From: tip-bot for Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       davem@davemloft.net, fweisbec@gmail.com,
       nobuhiro.iwamatsu.yj@renesas.com, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, fweisbec@gmail.com,
       nobuhiro.iwamatsu.yj@renesas.com, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
References: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix argument of perf_arch_fetch_caller_regs
Message-ID: <tip-5cfaf214856eb934759ae500a0b812dd06a00bd9@git.kernel.org>
Git-Commit-ID: 5cfaf214856eb934759ae500a0b812dd06a00bd9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Jun 2010 13:25:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cfaf214856eb934759ae500a0b812dd06a00bd9
Gitweb:     http://git.kernel.org/tip/5cfaf214856eb934759ae500a0b812dd06a00bd9
Author:     Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
AuthorDate: Wed, 23 Jun 2010 09:17:53 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 24 Jun 2010 23:34:58 +0200

perf: Fix argument of perf_arch_fetch_caller_regs

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
