Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab2GFTc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 15:32:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36343 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2GFTcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 15:32:24 -0400
From: Eldad Zack <eldad@fogrefinery.com>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Joe Perches <joe@perches.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eldad Zack <eldad@fogrefinery.com>
Subject: [PATCH 1/2, resend] sunrpc/cache.h: fix coding style
Date: Fri,  6 Jul 2012 21:31:56 +0200
Message-Id: <1341603117-13064-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neaten code style in get_int().
Also use sizeof() instead of hard coded number as suggested by
Joe Perches <joe@perches.com>.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Eldad Zack <eldad@fogrefinery.com>
---
Resent to include improvements from Joe Perches.
 include/linux/sunrpc/cache.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index f5fd616..6def1f6 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -219,11 +219,17 @@ static inline int get_int(char **bpp, int *anint)
 	char buf[50];
 	char *ep;
 	int rv;
-	int len = qword_get(bpp, buf, 50);
-	if (len < 0) return -EINVAL;
-	if (len ==0) return -ENOENT;
+	int len = qword_get(bpp, buf, sizeof(buf));
+
+	if (len < 0)
+		return -EINVAL;
+	if (len == 0)
+		return -ENOENT;
+
 	rv = simple_strtol(buf, &ep, 0);
-	if (*ep) return -EINVAL;
+	if (*ep)
+		return -EINVAL;
+
 	*anint = rv;
 	return 0;
 }
-- 
1.7.10

