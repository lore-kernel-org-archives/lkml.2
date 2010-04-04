Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0DDOhG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:37:06 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53038 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab0DDOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Zri0oF3RXoWxY94+7lKiOwDvuv1q5BPW8eEFA9dQtzDbLE+Qt/TBn89TapGxef4OSI
         uM83TSJ2LDQ40ZZ4ZBmssm1jtd+0DQ9lbgA29YZoQsxQ0obcDA2Cl8TS2VaTszdQWFWv
         gZVGc6v08LCA8gWl9qaGuGEpZDhZn/ItY0bM8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/4] perf: Drop the frame reliablity check
Date: Sun,  4 Apr 2010 16:36:41 +0200
Message-Id: <1270391804-6552-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
References: <1270391804-6552-1-git-send-regression-fweisbec@gmail.com>
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
index 65e9c5e..353a174 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1602,8 +1602,7 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 {
 	struct perf_callchain_entry *entry = data;
 
-	if (reliable)
-		callchain_store(entry, addr);
+	callchain_store(entry, addr);
 }
 
 static const struct stacktrace_ops backtrace_ops = {
-- 
1.6.2.3

