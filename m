Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1HKTi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:38:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15409 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1HKThr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:37:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=lrPe1Wm9bbCmOL6gywRZLfbzL5Mk0IUJewfQVZO60M6GKImKqJQ+qq7q/YIXk1IUM
	TFsprE1PaqB6j1yNqA45A==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/5] trace-cmd: Don't call exit from tracecmd_blk_hack()
Date: Thu, 11 Aug 2011 12:37:36 -0700
Message-Id: <1313091459-12049-2-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
References: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9e0fd22b14805a3a3219a99bc5eccebf70f5484a adds a hack to parse
blktrace events. In tracecmd_blk_hack(), if the block trace events could
not be parsed, it calls exit(0). Get rid of it and only return -1 to let
the caller know that parsing failed.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-blk-hack.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/trace-blk-hack.c b/trace-blk-hack.c
index bdc9d13..b5b78e3 100644
--- a/trace-blk-hack.c
+++ b/trace-blk-hack.c
@@ -159,7 +159,5 @@ int tracecmd_blk_hack(struct tracecmd_input *handle)
 	return 0;
 
  fail:
-	exit(0);
-	printf("failed!\n");
 	return -1;
 }
-- 
1.7.3.1

