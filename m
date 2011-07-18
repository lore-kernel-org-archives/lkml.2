Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1GRVp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:45:57 -0400
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:51587 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab1GRVp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:45:56 -0400
Message-ID: <4E24A699.4070300@bx.jp.nec.com>
Date: Mon, 18 Jul 2011 17:33:13 -0400
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Keiichi KII <k-keiichi@bx.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "BA, Moussa" <Moussa.BA@numonyx.com>
Subject: [RFC PATCH -tip 1/5] perf tools: handle '-' and '*' in trace parsing
References: <4E24A61D.4060702@bx.jp.nec.com>
In-Reply-To: <4E24A61D.4060702@bx.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keiichi Kii <k-keiichi@bx.jp.nec.com>

add '-' and '*' to parsing in trace parsing.

Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>
---

 tools/perf/util/trace-event-parse.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)


diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..447f7c0 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2162,6 +2162,12 @@ static unsigned long long eval_num_arg(void *data, int size,
 		case '+':
 			val = left + right;
 			break;
+		case '*':
+			val = left * right;
+			break;
+		case '/':
+			val = left / right;
+			break;
 		default:
 			die("unknown op '%s'", arg->op.op);
 		}


