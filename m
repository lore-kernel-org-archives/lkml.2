Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1CJAGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:06:01 -0500
Received: from smtp-out.google.com ([74.125.121.67]:40918 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1CJAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:05:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=PxAoOJ8Hl3uq/IfpLi+CfvkXudZo2kcPLwpDJSW3OkI5OP09QL2PXMNMwL6AbNhOS
	anc9HsTGuP3SbCQEKcEvg==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH trace-cmd 1/3] parse-events: Add support for printing short fields.
Date: Wed,  9 Mar 2011 15:58:55 -0800
Message-Id: <1299715137-22768-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle "%hd" etc. in pretty_print()

Signed-off-by: David Sharp <dhsharp@google.com>
Google-Bug-Id: 3501052
---
 parse-events.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 3d59d92..bfb7ff5 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -3607,6 +3607,9 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 			case '#':
 				/* FIXME: need to handle properly */
 				goto cont_process;
+			case 'h':
+				ls--;
+				goto cont_process;
 			case 'l':
 				ls++;
 				goto cont_process;
@@ -3687,6 +3690,18 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 						strcpy(format, "0x%llx");
 				}
 				switch (ls) {
+				case -2:
+					if (len_as_arg)
+						trace_seq_printf(s, format, len_arg, (char)val);
+					else
+						trace_seq_printf(s, format, (char)val);
+					break;
+				case -1:
+					if (len_as_arg)
+						trace_seq_printf(s, format, len_arg, (short)val);
+					else
+						trace_seq_printf(s, format, (short)val);
+					break;
 				case 0:
 					if (len_as_arg)
 						trace_seq_printf(s, format, len_arg, (int)val);
-- 
1.7.3.1

