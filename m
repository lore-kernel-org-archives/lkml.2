Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0I3Dui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:38 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0I3Dug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JUPK5SFn/ozAzBsoQ7wFXbh3h3sgKECuWZwLiY67akDg95i76NT3UHvn5bF/JZuWQf
         FRjwZO9XYrW41DcLqPm+hdTMfSgyqRcMGRHWTTyHytBVX3E47F6lmY+XUfaGJi9bFSjb
         OF+rDFaQ6jvQ8rmANegS4MH1ETnngUTxViwU8=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] mm: add casts to/from gfp_t in gfp_to_alloc_flags()
Date: Thu, 30 Sep 2010 12:50:11 +0900
Message-Id: <1285818621-29890-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes following warning from sparse:

 mm/page_alloc.c:1934:9: warning: restricted gfp_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a8cfa9c..7c4e5b1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1931,7 +1931,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
 	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
-	BUILD_BUG_ON(__GFP_HIGH != ALLOC_HIGH);
+	BUILD_BUG_ON(__GFP_HIGH != (__force gfp_t) ALLOC_HIGH);
 
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
@@ -1939,7 +1939,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	alloc_flags |= (gfp_mask & __GFP_HIGH);
+	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
 
 	if (!wait) {
 		alloc_flags |= ALLOC_HARDER;
-- 
1.7.2.2

