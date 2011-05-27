Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1E0NLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:11:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64142 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1E0NLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=M1CvWpBChQUE5oIA1WiiMcw61P9//VGk6Z5+z9dfQfeh4RZ6PgEIz1GUUBa0OIFnKY
         8DIJL0vcFI6yNyt5G3+1Xum/TnCMPjodAnjnvPNixpjObMywhwASX3ZUPlTGi1fhUqo2
         EmoCLOR8c72+N4Sw1/2ZMlOEOG/us0a4eF3lw=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] blktrace: treat flush as barrier
Date: Fri, 27 May 2011 22:11:22 +0900
Message-Id: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since BARRIER requests have been converted to FLUSH/FUA, it would be
better for blktrace to recognize FLUSH requests as BARRIER for the
backward-compatibility IMHO.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
---
 kernel/trace/blktrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 6957aa298dfa..8635d332c50b 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -176,6 +176,7 @@ static const u32 ddir_act[2] = { BLK_TC_ACT(BLK_TC_READ),
 				 BLK_TC_ACT(BLK_TC_WRITE) };
 
 #define BLK_TC_RAHEAD		BLK_TC_AHEAD
+#define BLK_TC_FLUSH		BLK_TC_BARRIER
 
 /* The ilog2() calls fall out because they're constant */
 #define MASK_TC_BIT(rw, __name) ((rw & REQ_ ## __name) << \
@@ -206,6 +207,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	what |= MASK_TC_BIT(rw, RAHEAD);
 	what |= MASK_TC_BIT(rw, META);
 	what |= MASK_TC_BIT(rw, DISCARD);
+	what |= MASK_TC_BIT(rw, FLUSH);
 
 	pid = tsk->pid;
 	if (act_log_check(bt, what, sector, pid))
-- 
1.7.5.2

