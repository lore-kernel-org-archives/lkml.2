Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1EVBqE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 21:46:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45810 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab1EVBp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 21:45:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sXQVQAkOiAPzauh/+s1T+aamb3EOtWHaqePvfXroEHMOPJV8EkXMgNKt9PHgea7As8
         TX+YpbQuDP5A3hsPLg+sDhvbv0aHIUHLbESjtkLzkJevtfnVs6owSOPfByiHkym22iM+
         /GyQGwuVhApz1dlT2+WlKU31d2dBpuELJgP7Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/6] perf tools: Remove junk code in mmap size handling
Date: Sun, 22 May 2011 03:45:40 +0200
Message-Id: <1306028744-10603-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
References: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size is overriden later and used only then. Those
lines are only junk, probably a leftover.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 61746b5..db65206 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1018,9 +1018,6 @@ more:
 
 	if (session->header.needs_swap)
 		perf_event_header__bswap(&event->header);
-	size = event->header.size;
-	if (size == 0)
-		size = 8;
 
 	if (head + event->header.size > mmap_size) {
 		if (mmaps[map_idx]) {
-- 
1.7.3.2

