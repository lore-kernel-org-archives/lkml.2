Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0FWASP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 20:18:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46596 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab0FWASO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 20:18:14 -0400
MIME-Version: 1.0
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Wed, 23 Jun 2010 09:17:53 +0900
X-Google-Sender-Auth: cDKm1hed0bXmhHsXS6my_k_0fr0
Message-ID: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
Subject: [PATCH] perf: Fix argument of perf_arch_fetch_caller_regs
To: linux-kernel@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"struct regs" was set to argument of perf_arch_fetch_caller_regs.
"struct pt_regs" is correct.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9073bde..b65736d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -934,7 +934,7 @@ extern void __perf_sw_event(u32, u64, int, struct
pt_regs *, u64);

 #ifndef perf_arch_fetch_caller_regs
 static inline void
-perf_arch_fetch_caller_regs(struct regs *regs, unsigned long ip) { }
+perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
 #endif

 /*
-- 
1.7.1
