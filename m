Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1CGU13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:27:29 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56710 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab1CGU1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:27:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PZ5j++UHCF1N5xjSp/8eFsZFpbIdZZEP3/4wGbAe0ftfSjg4HjSGusrERBf6Vief25
         ucD5z6hP1tpCUjl1ibXxZyg1DWWWJHryHzlppU6Q/04AqJnatjl4ky9QICdoo79ngEo3
         gYUi6TM9hCcN+WlYc4li7186TW1ttAuVwJLaU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf: Handle stopped state with tracepoints
Date: Mon,  7 Mar 2011 21:27:09 +0100
Message-Id: <1299529629-18280-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
References: <1299529629-18280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We toggle the state from start and stop callbacks but actually
don't check it when the event triggers. Do it so that
these callbacks actually work.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/perf_event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 974e2e6..533f715 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5478,6 +5478,8 @@ static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
+	if (event->hw.state & PERF_HES_STOPPED)
+		return 0;
 	/*
 	 * All tracepoints are from kernel-space.
 	 */
-- 
1.7.3.2

