Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0JPDqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 23:46:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45820 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0JPDqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 23:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MSOnz6eAPRjMaZG8JCQD0KYysn0HCR3o/DLYB1IsAlsDLXOPHe1XLdJ1+fG7v54jj2
         W1jQ5T3HXZfZhNH/e36DioBqp4Ra2XvFt4Qf1uX5hpwznhAw6P4g7gwrzSpi7CIZx6BD
         ZHiK9Mk2xDwp54Mcf7d7GPIxepYouWbSIsn24=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/buffer.c: remove duplicated assignment on b_private
Date: Sat, 16 Oct 2010 12:40:33 +0900
Message-Id: <1287200433-2895-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bh->b_private is initialized within init_buffer(), thus the
assignment should be redundant. Remove it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/buffer.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3e7dca2..133ae58 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -905,7 +905,6 @@ try_again:
 
 		bh->b_state = 0;
 		atomic_set(&bh->b_count, 0);
-		bh->b_private = NULL;
 		bh->b_size = size;
 
 		/* Link the buffer to its page */
-- 
1.7.0.4

