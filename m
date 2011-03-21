Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1CUWfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 18:35:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1CUWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:34:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=L7ARfMRI87lAbr64oss2P55bT16cQEz9Z/D1txRLKGdHWPwSsVcCWRs2ilm7X4tXk
	A27TNtmY9aZvB8e9xjghw==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH perf 2/2] perf: trace-event-parse: support printing short fields
Date: Mon, 21 Mar 2011 15:34:06 -0700
Message-Id: <1300746846-28245-3-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300746846-28245-1-git-send-email-dhsharp@google.com>
References: <1300746846-28245-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle "%hd" etc. in pretty_print()

Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/trace-event-parse.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 67fe01a..0cf4366 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -2534,6 +2534,9 @@ static void pretty_print(void *data, int size, struct event *event)
 			case '%':
 				printf("%%");
 				break;
+			case 'h':
+				ls--;
+				goto cont_process;
 			case 'l':
 				ls++;
 				goto cont_process;
@@ -2589,6 +2592,12 @@ static void pretty_print(void *data, int size, struct event *event)
 					}
 				}
 				switch (ls) {
+				case -2:
+					printf(format, (char)val);
+					break;
+				case -1:
+					printf(format, (short)val);
+					break;
 				case 0:
 					printf(format, (int)val);
 					break;
-- 
1.7.3.1

