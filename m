Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab1CaBdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:33:38 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45260 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab1CaBdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:33:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CwfWV9c8pJQ1k3OBrZp8oa6nd/GX5lgqywNZVf8viGRLHCzutCWmzAuYFar5CY0gNY
         NAQT3cw/zTFI9VZtXwfGbAecdRc4XG1WTgWIQpYdJq+7ROTn5g0mziNN9T2oRhgNlnOe
         51nDbxaUfyk2EYVcvd/P1mAglWZcpUHoRjf7s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Stable <stable@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2 v2] perf: Rebase max unprivileged mlock threshold on top of page size
Date: Thu, 31 Mar 2011 03:33:29 +0200
Message-Id: <1301535209-9679-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1301496028.4859.183.camel@twins>
References: <1301496028.4859.183.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure we allow 512 kiB + 1 page for user control without
assuming a 4096 page size.

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stable <stable@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/perf_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c75925c..2616909 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -145,8 +145,8 @@ static struct srcu_struct pmus_srcu;
  */
 int sysctl_perf_event_paranoid __read_mostly = 1;
 
-/* Minimum for 128 pages + 1 for the user control page */
-int sysctl_perf_event_mlock __read_mostly = 516; /* 'free' kb per user */
+/* Minimum for 512 kiB + 1 user control page */
+int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
 
 /*
  * max perf event sample rate
-- 
1.7.3.2

