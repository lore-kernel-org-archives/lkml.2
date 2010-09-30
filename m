Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0I3Du5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:50:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56474 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0I3Duy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=w10XMQEs11Sh7mqecdp/MnR81UsuvLFjFpzQxld9IrriI2VFBI568A4teR+uQFznqk
         T03V9IAvcKT8HcMAeOW0VjbH0A79MGBF0XH3mfLm410uIf51uKXdNAuQqKUxNGm8TdIF
         IFGckbZBxVbAwGbq0ApGnuZ2fT/dHXWinEOHw=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] vmalloc: rename temporary variable in __insert_vmap_area()
Date: Thu, 30 Sep 2010 12:50:18 +0900
Message-Id: <1285818621-29890-10-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
References: <1285818621-29890-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename redundant 'tmp' to fix following sparse warnings:

 mm/vmalloc.c:296:34: warning: symbol 'tmp' shadows an earlier one
 mm/vmalloc.c:293:24: originally declared here

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/vmalloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6b8889d..7ce8ca5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -293,13 +293,13 @@ static void __insert_vmap_area(struct vmap_area *va)
 	struct rb_node *tmp;
 
 	while (*p) {
-		struct vmap_area *tmp;
+		struct vmap_area *tmp_va;
 
 		parent = *p;
-		tmp = rb_entry(parent, struct vmap_area, rb_node);
-		if (va->va_start < tmp->va_end)
+		tmp_va = rb_entry(parent, struct vmap_area, rb_node);
+		if (va->va_start < tmp_va->va_end)
 			p = &(*p)->rb_left;
-		else if (va->va_end > tmp->va_start)
+		else if (va->va_end > tmp_va->va_start)
 			p = &(*p)->rb_right;
 		else
 			BUG();
-- 
1.7.2.2

