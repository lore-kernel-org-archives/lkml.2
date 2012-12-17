Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2LQNhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:37:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2LQNhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:37:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] perf tool: Add '.' as part of the event 'name' token
Date: Mon, 17 Dec 2012 14:37:03 +0100
Message-Id: <1355751425-7993-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding '.' to be recognized as valid part of the event 'name'
token. Upcoming non architectural events use '.' as part
of the name.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/util/parse-events.l | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index e9d1134..15263f0 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -80,8 +80,8 @@ event		[^,{}/]+
 num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
-name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
+name		[a-zA-Z_*?][a-zA-Z0-9_*?\.]*
+name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?\.]*
 modifier_event	[ukhpGH]+
 modifier_bp	[rwx]{1,3}
 
-- 
1.7.11.7

