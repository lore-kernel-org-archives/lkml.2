Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1ALMUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:20:09 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:40507 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1ALMUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:20:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZjQs1BqiYvEzttQztLTWk1yQS+Azkyj7jFsnEhNlnuhaxilVWtOJX03lsVmaA11ihB
         R/sNy6vYE8qy8iKNJOTE75ZIvahg/sbJ5AjRABBYIKGlttW/p5sd/qMvsqlH6Dg64VCl
         SYY11ppmoC4cBmhRVwPsSGBT1J81NgyHC0TAg=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: use kmalloc() in ep_alloc()
Date: Wed, 12 Jan 2011 21:19:55 +0900
Message-Id: <1294834795-3987-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmalloc() instead of kzalloc() in ep_alloc(). It seems that
no need to zero-initialize struct eventpoll simply because all
of the fields in the struct will be set properly right after.

The struct might contain paddings in it but IMHO it would not
be a problem since it will not be accessed from the outside of
epoll code.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/eventpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 2e21fb85b8b6..bdea67ed9762 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -728,7 +728,7 @@ static int ep_alloc(struct eventpoll **pep)
 
 	user = get_current_user();
 	error = -ENOMEM;
-	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	ep = kmalloc(sizeof(*ep), GFP_KERNEL);
 	if (unlikely(!ep))
 		goto free_uid;
 
-- 
1.7.3.4.600.g982838b0

