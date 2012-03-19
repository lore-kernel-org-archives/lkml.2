Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2CSU2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:28:47 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:59656 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab2CSU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:28:46 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/2] Revert "trace-cmd: Add function declaration to fix compile warning"
Date: Mon, 19 Mar 2012 13:28:42 -0700
Message-Id: <1332188923-13375-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 1fc4fb039bfa3f0358d7e9810de71c58a7b32b64.

Steven added commit ba911ea7fc1fdd13e3bce1b2001f5b432df8edae which does
exactly the same thing. Now we end up with a duplicate declaration of
the function trace_util_ftrace_options(). Reverting the commit gets rid
of the warning.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-cmd.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index 3f522ee..f904dc5 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -218,7 +218,6 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 /* --- Plugin handling --- */
 extern struct plugin_option trace_ftrace_options[];
 
-void trace_util_ftrace_options(void);
 void trace_util_add_option(const char *name, const char *val);
 void trace_util_load_plugins(struct pevent *pevent, const char *suffix,
 			     void (*load_plugin)(struct pevent *pevent,
-- 
1.7.7.3

