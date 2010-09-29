Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0I2AAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:00:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45196 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0I2AAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:00:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=JmyLJkWZpY9czPOKKQyLz+vSZSYB0QHBeAztJjMeHEbbkyU2X7aCBj/QLOPQvHpUB
	Xsa2CzxCfLhNwVGbXqTIg==
From: David Sharp <dhsharp@google.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, mrubin@google.com,
        David Sharp <dhsharp@google.com>
Subject: [PATCH] trace-cmd: Search $TRACE_CMD_PLUGIN_DIR for plugins.
Date: Tue, 28 Sep 2010 17:00:16 -0700
Message-Id: <1285718416-1470-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows dynamic specification of the plugin directory so that plugins can be
used when the install prefix cannot be predicted, such as when using a
pre-compiled version of trace-cmd with Autotest.

Signed-off-by: David Sharp <dhsharp@google.com>
---
 trace-util.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/trace-util.c b/trace-util.c
index 33dbdf0..9e0ceca 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -771,6 +771,7 @@ void trace_util_load_plugins(struct pevent *pevent, const char *suffix,
 {
 	char *home;
 	char *path;
+        char *envdir;
 
 	if (tracecmd_disable_plugins)
 		return;
@@ -782,7 +783,12 @@ void trace_util_load_plugins(struct pevent *pevent, const char *suffix,
 					    load_plugin, data);
 #endif
 
-	/* Now let the home directory override the system defaults */
+	/* Next let the environment-set plugin directory override the system defaults */
+	envdir = getenv("TRACE_CMD_PLUGIN_DIR");
+	if (envdir)
+		trace_util_load_plugins_dir(pevent, suffix, envdir, load_plugin, data);
+
+	/* Now let the home directory override the environment or system defaults */
 	home = getenv("HOME");
 
 	if (!home)
-- 
1.7.1

