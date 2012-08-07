Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2HGRol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:44:41 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:19231
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755851Ab2HGRoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8EBY5-02-019-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/6] perf, tools: Fix version file for perf documentation with OUTPUT variable set
Date: Tue, 7 Aug 2012 19:43:11 +0200
Message-ID: <1344361396-7237-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following:

 + make OUTPUT=/.../.build/perf-user/ DESTDIR=/.../.install/perf-user/ man install-man
 make -C Documentation man
 make[1]: Entering directory `/.../.source/linux.perf/tools/perf/Documentation'
 make[2]: Entering directory `/.../.source/linux.perf/tools/perf'
 make[2]: *** No rule to make target `PERF-VERSION-FILE'.  Stop.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/Documentation/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index ca600e0..9f2e44f 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -195,10 +195,10 @@ install-pdf: pdf
 #install-html: html
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
-../PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) PERF-VERSION-FILE
+$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
 
--include ../PERF-VERSION-FILE
+-include $(OUTPUT)PERF-VERSION-FILE
 
 #
 # Determine "include::" file references in asciidoc files.
-- 
1.7.8.4


