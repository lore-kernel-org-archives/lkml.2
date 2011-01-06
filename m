Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1AFOwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:52:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49622 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab1AFOwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FzL9Z4dkaQZt+Tsv2Qcs8RiubfMkWMPC6Pa+daSwUcPJYC+Ym5wytzpZzlnE5l8qfy
         lzmNhaQxJrbCEmBD5ciVuF6hMjpQWgPAzr6p34YiJrKnktjSyaJWP2KYybxngXJWLYQI
         MbG4aN7DD6wzHHt2j0kuKLPe2O+1+uACwAC3g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf: Build tools with frame pointer
Date: Thu,  6 Jan 2011 15:51:53 +0100
Message-Id: <1294325513-14276-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
References: <1294325513-14276-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that some gcc versions build by default with frame pointers
and some others omit them.

Just build the tools with frame pointers as the callchains can be an
important part of the perf workflow.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1b9b13e..2b5387d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -227,7 +227,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.7.3.2

