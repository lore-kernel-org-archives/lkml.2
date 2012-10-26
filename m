Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412Ab2JZOcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:32:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:44282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371Ab2JZOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:32:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@amd64.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/9] perf tools: Always show CHK message when doing try-cc
Date: Fri, 26 Oct 2012 12:31:48 -0200
Message-Id: <1351261913-28250-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351261913-28250-1-git-send-email-acme@infradead.org>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It might be useful to see what's happening behind us rather than just
waiting few seconds during the config checking.

Also align the CHK message with other ones.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351241752-2919-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index ea853c2..e541312 100644
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
1.7.9.2.358.g22243

