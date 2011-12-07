Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1LGBhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:37:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51882 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab1LGBhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:37:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EDEC331.7020506@jp.fujitsu.com>
Date: Wed, 07 Dec 2011 10:36:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-btrfs@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 1/3] perf: parse greater/less than or equal
References: <4EDEC207.90403@jp.fujitsu.com>
In-Reply-To: <4EDEC207.90403@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some btrfs tracepoints have complex format like following, but perf
command failed to parse it:

   print fmt: "%s",  ((REC->id >= min) || (REC->id <= max )) ?
        __print_symbolic(REC->id, { 1ULL, "ROOT_TREE" }, ... ) : "-"

  $ perf script
  Warning: unknown op '>='
  Warning: Error: expected type 5 but read 1
  Warning: failed to read event print fmt for btrfs_transaction_commit

This patch allow perf command to parse operation tokens, '>=' and '<='.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 tools/perf/util/trace-event-parse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..c2adc76 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1229,6 +1229,8 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "/") == 0 ||
 		   strcmp(token, "<") == 0 ||
 		   strcmp(token, ">") == 0 ||
+		   strcmp(token, "<=") == 0 ||
+		   strcmp(token, ">=") == 0 ||
 		   strcmp(token, "==") == 0 ||
 		   strcmp(token, "!=") == 0) {
 
-- 
1.7.7.3


