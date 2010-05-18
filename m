Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab0ERVYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:24:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49067 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0ERVYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=px0FaZtVzxY6xbR/aBnFXxZg3/nqVAbCyk9p0vhjdZ+ol9Rj5O5WR0hi/3RmVIX11y
         /wITH56ailHytcWD6VyKY+xnUmWTsuEGnHGuo+FiTL+tE/4W8QitYU4i+IAvYewLplf6
         9qbtNtx0xmQMDsUSp3ykHIyYCwsJ1OWGRtK4M=
Message-Id: <20100518212439.354345151@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 19 May 2010 01:19:19 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 3/4] x86,perf: P4 PMU -- add missing bit in CCCR mask
References: <20100518211916.407689068@openvz.org>
Content-Disposition: inline; filename=x86-perf-p4-cccr-mask-ht-t1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be there is a sake of RAW events.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/perf_event_p4.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -89,7 +89,8 @@
 	P4_CCCR_ENABLE)
 
 /* HT mask */
-#define P4_CCCR_MASK_HT	(P4_CCCR_MASK | P4_CCCR_THREAD_ANY)
+#define P4_CCCR_MASK_HT				\
+	(P4_CCCR_MASK | P4_CCCR_OVF_PMI_T1 | P4_CCCR_THREAD_ANY)
 
 #define P4_GEN_ESCR_EMASK(class, name, bit)	\
 	class##__##name = ((1 << bit) << P4_ESCR_EVENTMASK_SHIFT)

