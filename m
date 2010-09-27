Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab0I0KlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:41:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43309 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab0I0KlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZbAHrb1ZgVrCkCnNfhlPooSfcMGj9YnIFqxqmhW9+tpdX03qDbD10foPP7XRyjjtPM
         YzEc3RyubtpQQpxJu+grjvP3DOr1Yp1mjj8WQrWtG5MF1eTKegHNiuOft6j4Izqk6ccn
         UoPQDmPw99zF2xB8gYk7E65PCIpxPap5oh9/k=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] perf: Declare hw_perf_{dis,en}able() in perf_event.h
Date: Mon, 27 Sep 2010 19:39:57 +0900
Message-Id: <1285583997-1262-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since they can be defined in arch-specific code declare them in
perf_event.h and remove following warnings from sparse:

 kernel/perf_event.c:83:13: warning: symbol 'hw_perf_disable' was not declared. Should it be static?
 kernel/perf_event.c:84:13: warning: symbol 'hw_perf_enable' was not declared. Should it be static?

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/perf_event.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 167dd3d..26859c7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -848,6 +848,8 @@ struct perf_output_handle {
 extern int perf_max_events;
 
 extern const struct pmu *hw_perf_event_init(struct perf_event *event);
+extern void hw_perf_disable(void);
+extern void hw_perf_enable(void);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);
-- 
1.7.2.2

