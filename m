Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2KGTRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:17:14 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60499 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab2KGTRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:17:12 -0500
Date: Wed, 7 Nov 2012 11:18:19 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com
Cc: sukadev@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] perf/powerpc: Use uapi/unistd.h to fix build error
Message-ID: <20121107191818.GA16211@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110719-8974-0000-0000-000010CE970C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00189310; UDB=6.00042867; UTC=2012-11-07
 19:17:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From b8beef080260c1625c8f801105504a82005295e5 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 31 Oct 2012 11:21:28 -0700
Subject: [PATCH 1/4] perf/powerpc: Use uapi/unistd.h to fix build error

Use the 'unistd.h' from arch/powerpc/include/uapi to build the perf tool.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/perf.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 054182e..f4952da 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -26,7 +26,7 @@ void get_term_dimensions(struct winsize *ws);
 #endif
 
 #ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
+#include "../../arch/powerpc/include/uapi/asm/unistd.h"
 #define rmb()		asm volatile ("sync" ::: "memory")
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #define CPUINFO_PROC	"cpu"
-- 
1.7.1

