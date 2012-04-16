Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2DPU3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:29:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:36927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2DPU3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:29:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Otavio Salvador <otavio@ossystems.com.br>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf tools: Drop CROSS_COMPILE from flex and bison calls
Date: Mon, 16 Apr 2012 17:29:07 -0300
Message-Id: <1334608147-30588-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334608147-30588-1-git-send-email-acme@infradead.org>
References: <1334608147-30588-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Otavio Salvador <otavio@ossystems.com.br>

The flex and bison tools generate arch-independent C code so its
binaries are not prefixed with the target-arch prefix. With this patch
the Linux 3.4-rc2 can be successfuly build on OE-Core.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
Link: http://lkml.kernel.org/r/1334148270-13139-1-git-send-email-otavio@ossystems.com.br
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 03059e7..9bf3fc7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -234,8 +234,8 @@ endif
 
 export PERL_PATH
 
-FLEX = $(CROSS_COMPILE)flex
-BISON= $(CROSS_COMPILE)bison
+FLEX = flex
+BISON= bison
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
-- 
1.7.9.2.358.g22243

