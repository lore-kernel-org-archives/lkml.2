Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab2IJLeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 07:34:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43028 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab2IJLeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 07:34:02 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] proc: Use NULL instead of 0 for pointer
Date: Mon, 10 Sep 2012 17:00:50 +0530
Message-Id: <1347276650-8130-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleanup also fixes the following sparse warning:
fs/proc/root.c:64:45: warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 fs/proc/root.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 9a2d9fd..9889a92 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -61,7 +61,7 @@ static int proc_parse_options(char *options, struct pid_namespace *pid)
 		if (!*p)
 			continue;
 
-		args[0].to = args[0].from = 0;
+		args[0].to = args[0].from = NULL;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_gid:
-- 
1.7.4.1

