Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1CGU1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:27:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1CGU1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:27:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LcFfOdRo1P3F6oQkSbn1L5AxCTZqZlI6X1Ay2lv0POXWSf6FDfMKdY/jji36UiCHia
         R5dOKKPy0xgCHac2yMt3bpNvyCk+p/4zKTjqjBErHcujpc/w7DoX6h9r5rVhQqk7Z2LV
         5sezJ62G598tGCbMQNExorwH/44+hESTGtUns=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf: Fix the software events state check
Date: Mon,  7 Mar 2011 21:27:08 +0100
Message-Id: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the mistakenly inverted check of events state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ed253aa..974e2e6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5122,7 +5122,7 @@ static int perf_exclude_event(struct perf_event *event,
 			      struct pt_regs *regs)
 {
 	if (event->hw.state & PERF_HES_STOPPED)
-		return 0;
+		return 1;
 
 	if (regs) {
 		if (event->attr.exclude_user && user_mode(regs))
-- 
1.7.3.2

