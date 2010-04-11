Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304Ab0DKFXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 01:23:16 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:64448 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab0DKFXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 01:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=O35jh5FhgqkrnpXciNY4kss7rtPKyodS2TUU5qgXSOLUJxJP8q9qJuCIVqJ6h3dZA0
         pNMfs4M8JJF34FmCi0i16KpCLSccx2vOhHg7haRe46Lnz2HgYfWnwnI2RT92hpnmbrXO
         KDZk9bqYJQ3kDMO/Rga0TgrpWLth1y3KH3bU0=
MIME-Version: 1.0
Date: Sun, 11 Apr 2010 13:23:12 +0800
Message-ID: <m2i5a774f4c1004102223zbfc0ce63u4e8682b69e7d8088@mail.gmail.com>
Subject: [PATCH] Fix inappropriate substraction on tracing_pages_allocated in 
	trace_free_page()in 2.6.27.y series kernel
From: shenghui <crosslonelyover@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed inappropriate substraction on variable
tracing_pages_allocated in trace_free_page()in 2.6.27.y series (from
2.6.27 to 2.6.27.46) kernel.


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>

---
 kernel/trace/trace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8f3fb3d..dfe3995 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3018,7 +3018,6 @@ static int trace_free_page(void)
 		ClearPageLRU(page);
 		list_del(&page->lru);
 		tracing_pages_allocated--;
-		tracing_pages_allocated--;
 		__free_page(page);

 		tracing_reset(data);
@@ -3036,6 +3035,7 @@ static int trace_free_page(void)
 		page = list_entry(p, struct page, lru);
 		ClearPageLRU(page);
 		list_del(&page->lru);
+		tracing_pages_allocated--;
 		__free_page(page);

 		tracing_reset(data);
