Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2JZI5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:57:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46717 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab2JZI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:56:35 -0400
X-AuditID: 9c930179-b7c8bae000003559-56-508a503f9f70
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@amd64.org>
Subject: [PATCH 4/5] perf tools: Always show CHK message when doing try-cc
Date: Fri, 26 Oct 2012 17:55:51 +0900
Message-Id: <1351241752-2919-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It might be useful to see what's happening behind us rather than just
waiting few seconds during the config checking.

Also align the CHK message with other ones.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/config/utilities.mak | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index ea853c279b31..e5413125e6bb 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -183,9 +183,8 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 # Usage: option = $(call try-cc, source-to-build, cc-options, msg)
 ifndef V
 TRY_CC_OUTPUT= > /dev/null 2>&1
-else
-TRY_CC_MSG=echo "CHK $(3)" 1>&2;
 endif
+TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
 
 try-cc = $(shell sh -c						  \
 	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
-- 
1.7.11.7

