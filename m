Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2DKMmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:42:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59485 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2DKMmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:42:51 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>
Subject: [PATCH] perf: do not prefix flex and bison calls with CROSS_COMPILE prefix
Date: Wed, 11 Apr 2012 09:44:30 -0300
Message-Id: <1334148270-13139-1-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other parts of kernel calls bison and flex but do not use the
CROSS_COMPILE prefix so this ought to be done in same way.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
---
 tools/perf/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 820371f..0ae8165 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -234,8 +234,8 @@ endif
 
 export PERL_PATH
 
-FLEX = $(CROSS_COMPILE)flex
-BISON= $(CROSS_COMPILE)bison
+FLEX = flex
+BISON= bison
 
 event-parser:
 	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
-- 
1.7.9.5

