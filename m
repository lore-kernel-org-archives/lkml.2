Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0IVQpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:45:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58857 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0IVQpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=XsTxWr5sLNBugXLDciNlrMT3j7xPzOkAu9Wvr+lDxv4QOrRrqanweAGNxuxik2g56/
         tb51/KI5jXSKMm/M3QoRaSnXrFiY/U+zBkQbKuNztk3pZan8YXiTEUWlPVPiGVV5zwXO
         VfU5x6R0smtJNGAmbkwZfAzOpWGrwHp2lV8UU=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 17:45:45 +0100
Message-ID: <AANLkTikR1gKSqTr4xUp6R=juBtPOW4ckf+vnd9YR+4Kz@mail.gmail.com>
Subject: [2.6.36-rc5] TTM fixes...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct allocation flags type and function prototype for ANSI C compliance.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c
b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index ca90479..b1e02ff 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -69,7 +69,7 @@ struct ttm_page_pool {
     spinlock_t        lock;
     bool            fill_lock;
     struct list_head    list;
-    int            gfp_flags;
+    gfp_t            gfp_flags;
     unsigned        npages;
     char            *name;
     unsigned long        nfrees;
@@ -475,7 +475,7 @@ static void
ttm_handle_caching_state_failure(struct list_head *pages,
  * This function is reentrant if caller updates count depending on number of
  * pages returned in pages array.
  */
-static int ttm_alloc_new_pages(struct list_head *pages, int gfp_flags,
+static int ttm_alloc_new_pages(struct list_head *pages, gfp_t gfp_flags,
         int ttm_flags, enum ttm_caching_state cstate, unsigned count)
 {
     struct page **caching_array;
@@ -666,7 +666,7 @@ int ttm_get_pages(struct list_head *pages, int flags,
 {
     struct ttm_page_pool *pool = ttm_get_pool(flags, cstate);
     struct page *p = NULL;
-    int gfp_flags = GFP_USER;
+    gfp_t gfp_flags = GFP_USER;
     int r;

     /* set zero flag for page allocation if required */
@@ -818,7 +818,7 @@ int ttm_page_alloc_init(struct ttm_mem_global
*glob, unsigned max_pages)
     return 0;
 }

-void ttm_page_alloc_fini()
+void ttm_page_alloc_fini(void)
 {
     int i;
 --
Daniel J Blueman
