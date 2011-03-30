Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab1C3OEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:04:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48306 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1C3OEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:04:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vHeqNanYPW8Tkf16IMQnAJYuMdT5nyS1uVR+WNl1a+ccIjUiAV+EsvSLjIqP2sziM9
         P33/Gmvf8LTm20AQs1W+GM9TlzCmNGXM/fzKVHJPhc3PgyPkcul8/qgMNXIs0mzOry9U
         BiBzwVIFPiIJJ63VMn63EUAdqK5pQT3Ln6MCY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Stable <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf: Rebase max unprivileged mlock threshold on top of page size
Date: Wed, 30 Mar 2011 16:04:30 +0200
Message-Id: <1301493870-4551-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1301065512.2250.223.camel@laptop>
References: <1301065512.2250.223.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we ensure we allow 129 pages, even if the page size is
different than 4096.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stable <stable@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..fce1b8a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -146,7 +146,7 @@ static struct srcu_struct pmus_srcu;
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
 /* Minimum for 128 pages + 1 for the user control page */
-int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
+int sysctl_perf_event_mlock __read_mostly = (129 * PAGE_SIZE) / 1024; /* 'free' kb per user */
 
 /*
  * max perf event sample rate
-- 
1.7.3.2

