Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1GPDA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 23:00:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1GPDAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 23:00:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Z1KxUzUaZ/9RHk10bToYtostMNjksb8uM2LCeAnsykW/D5oNpSZgjZ0J9RID/ewp0
	kXLFqNZdHI7iSbivdIF1g==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 4/4] trace-cmd: Support '+' opcode in print format
Date: Fri, 15 Jul 2011 20:00:41 -0700
Message-Id: <1310785241-3799-4-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The '+' opcode is not supported in the arguments for the print format.
This patch adds support for it.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 parse-events.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 068c77f..2e39415 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -2033,6 +2033,18 @@ static int arg_num_eval(struct print_arg *arg, long long *val)
 				break;
 			*val = left - right;
 			break;
+		case '+':
+			if (arg->op.left->type == PRINT_NULL)
+				left = 0;
+			else
+				ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
+			*val = left + right;
+			break;
 		default:
 			do_warning("unknown op '%s'", arg->op.op);
 			ret = 0;
-- 
1.7.3.1

