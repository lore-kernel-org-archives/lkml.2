Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0ERCmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 22:42:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33458 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0ERCmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 22:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SD7sJZMJuVZBjgP0VFNyX3AMV70+59auJzHYrWDjLDCR7W+y1OS/dS01vMlWXnhhM7
         Gf3ymMTvq9m0HvHmCzzrWVIVAQW41JsqanVmdq3hw2Qoyc8RynYWTDDC4Q/uStxNXUL8
         IsTuEdIyWI7Baf1hI+4cES8yYKev+c2UNulGg=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]mm:highmem.h remove obsolete memclear_highpage_flush() call.
Date: Mon, 17 May 2010 19:42:05 -0700
Message-Id: <1274150525-2738-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memclear_highpage_flush has been changed over to
zero_user_page for some time now. I think it's
safe to say it's o.k. to remove all of it.
(but correct me if I'm wrong).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>


---
 include/linux/highmem.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 74152c0..c77f913 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -173,12 +173,6 @@ static inline void zero_user(struct page *page,
 	zero_user_segments(page, start, start + size, 0, 0);
 }
 
-static inline void __deprecated memclear_highpage_flush(struct page *page,
-			unsigned int offset, unsigned int size)
-{
-	zero_user(page, offset, size);
-}
-
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
 
 static inline void copy_user_highpage(struct page *to, struct page *from,
-- 
1.6.5.2.180.gc5b3e

