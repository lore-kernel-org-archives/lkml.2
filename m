Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2DRP6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:58:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45758 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2DRP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:58:01 -0400
From: Sasikantha babu <sasikanth.v19@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sasikantha babu <sasikanth.v19@gmail.com>
Subject: [PATCH] trace: modified is_good_name return type to bool
Date: Wed, 18 Apr 2012 21:30:41 +0530
Message-Id: <1334764841-13728-1-git-send-email-sasikanth.v19@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified is_good_name return type to bool, Since it returns either 0 or 1

Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
---
 kernel/trace/trace_kprobe.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 580a05e..c0a15ff 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -632,15 +632,15 @@ static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
 /* Check the name is good for event/group/fields */
-static int is_good_name(const char *name)
+static bool is_good_name(const char *name)
 {
 	if (!isalpha(*name) && *name != '_')
-		return 0;
+		return false;
 	while (*++name != '\0') {
 		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
-			return 0;
+			return false;
 	}
-	return 1;
+	return true;
 }
 
 /*
-- 
1.7.3.4

