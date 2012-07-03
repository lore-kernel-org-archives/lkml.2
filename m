Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2GCWBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab2GCWBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/10] perf, tool: Add empty rule for new line in event syntax parsing
Date: Wed,  4 Jul 2012 00:00:39 +0200
Message-Id: <1341352848-11833-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flex generator prints out each input character that is ignored
by lex rules.

Since the alias processing, we can have '\n' characters on input. We
need to assign empty rule to it, so it's not printed out.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.l |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 488362e..c05dbef 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -152,6 +152,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 ,			{ return ','; }
 :			{ return ':'; }
 =			{ return '='; }
+\n			{ }
 
 <mem>{
 {modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
-- 
1.7.10.4

