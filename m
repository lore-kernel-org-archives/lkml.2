Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0CZBxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:53:16 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:39839 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0CZBwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q7CyLBEgKcmkdnHsDxPAD777EntfV6uTOmDVjdFlrq4xol8BIjHzXkwGUzISrCfEZ5
         DyDPATU2LSIPEA7VBrxrZ/ydL/lFdDTqAPKXUoytBlb5g5hwYdicGzWOdGAm22F2WUMs
         QJhAjCdTISbwFrsQUcb1ofbmTyXoytrl+XceA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/7] perf: Drop the frame reliablity check
Date: Fri, 26 Mar 2010 02:52:36 +0100
Message-Id: <1269568362-13690-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
References: <1269568362-13690-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useless now that we have a pure stack frame
walker, as given addr are always reliable.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f571f51..9bc6550 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1597,8 +1597,7 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
-	if (reliable)
-		callchain_store(entry, addr);
+	callchain_store(entry, addr);
 }
 
 static const struct stacktrace_ops backtrace_ops = {
-- 
1.6.2.3

