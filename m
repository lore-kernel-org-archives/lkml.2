Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab0JHPoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:44:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33990 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0JHPoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RSZefdRPDUq1/RtBxGzkHdOCpJqRdYfTGK3mbJmVyTmlg8WJfZInif5Wf8167M6be0
         mv0rSF0wprwlxeFBrizBPBw9HRhXAoDfNNeLOeVCWvCyeEIacbShmuy8gPRqs1wL5V77
         MJX1RCHMpp94DnHDkn9OUB7Ur56S7QjkXAB4E=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/parser: cleanup match_number()
Date: Sat,  9 Oct 2010 00:44:17 +0900
Message-Id: <1286552657-3353-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new variable 'len' to make code more readable.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/parser.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/parser.c b/lib/parser.c
index fb34977..6e89eca 100644
--- a/lib/parser.c
+++ b/lib/parser.c
@@ -128,12 +128,13 @@ static int match_number(substring_t *s, int *result, int base)
 	char *endp;
 	char *buf;
 	int ret;
+	size_t len = s->to - s->from;
 
-	buf = kmalloc(s->to - s->from + 1, GFP_KERNEL);
+	buf = kmalloc(len + 1, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-	memcpy(buf, s->from, s->to - s->from);
-	buf[s->to - s->from] = '\0';
+	memcpy(buf, s->from, len);
+	buf[len] = '\0';
 	*result = simple_strtol(buf, &endp, base);
 	ret = 0;
 	if (endp == buf)
-- 
1.7.0.4

