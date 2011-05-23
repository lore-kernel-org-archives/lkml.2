Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1EWLGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:06:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54964 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1EWLGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kgF+9z7foPAls+Xx5ao2Bt4YEkFpFaZzqjPjuJtcWW3Uumc8gXDNkoXAlv6m8cMtOG
         lHs2+ssXlTbWTt7dPhV+4R60NN+bX5Eih+PrQH+TtmWztO3frw73ZfgVkOFDSJewMYAP
         oscjsyPcYFTqqJqUYISTW8Bve6+g4LnOMXpB0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf tools: Fix sample size bit operations
Date: Mon, 23 May 2011 13:06:27 +0200
Message-Id: <1306148788-6179-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
References: <1306148788-6179-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What we want is to count the number of bits in the mask,
not some other random operation written in the middle
of the night.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 17c1c3c..d3fa7e4 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -42,7 +42,7 @@ int perf_sample_size(u64 sample_type)
 	int i;
 
 	for (i = 0; i < 64; i++) {
-		if ((mask << i) & 1)
+		if (mask & (1 << i))
 			size++;
 	}
 
-- 
1.7.3.2

