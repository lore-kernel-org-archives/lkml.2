Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1CJW4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:56:33 -0500
Received: from smtp-out.google.com ([74.125.121.67]:22225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1CJW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:56:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=owKmQU4W1diZQMIyazM09Qk9lW1C/WwbRqDiDcdpnKb6ZPIocD9Ao9ePU1KzMoP7F
	ebR9cMaBO8JLVBZ/7IgwQ==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Subject: [PATCH perf 2/2] perf: trace-event-parse: support printing short fields
Date: Thu, 10 Mar 2011 14:55:56 -0800
Message-Id: <1299797756-13546-3-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299797756-13546-1-git-send-email-dhsharp@google.com>
References: <1299797756-13546-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle "%hd" etc. in pretty_print()

Signed-off-by: David Sharp <dhsharp@google.com>
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

