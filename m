Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab0JQOlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:41:20 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61194 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0JQOlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UpU/AjS+je4JmMGQIJThthhBbgTT41VN69RANtQnnzYh7/Ese/LZ6ZcaAgXe3I5zgg
         5Du7MjfRk/hYyFnBHkO+6Fh9oahi6pV4MqilTsYTmtxCsifMMwcbm6+4/BWPtPee2PKj
         KTdBKraAEifw2XEVjXuaBVyxxAHZL+4Dhpleo=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Julia Lawall <julia@diku.dk>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] char: applicom: fix information leak to userland
Date: Sun, 17 Oct 2010 18:41:12 +0400
Message-Id: <1287326472-7897-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure st_loc is copied to userland with some fields unitialized.
It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/char/applicom.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index e7ba774..25373df 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -566,6 +566,7 @@ static ssize_t ac_read (struct file *filp, char __user *buf, size_t count, loff_
 				struct mailbox mailbox;
 
 				/* Got a packet for us */
+				memset(&st_loc, 0, sizeof(st_loc));
 				ret = do_ac_read(i, buf, &st_loc, &mailbox);
 				spin_unlock_irqrestore(&apbs[i].mutex, flags);
 				set_current_state(TASK_RUNNING);
-- 
1.7.0.4

