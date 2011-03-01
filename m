Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1CAOJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:09:19 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:53503 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863Ab1CAOJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:09:18 -0500
Subject: [PATCH] drm: reorder drm_open_hash to remove padding on 64 bit
 builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: David Airlie <airlied@linux.ie>
Cc: lkml <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 14:09:16 +0000
Message-ID: <1298988556.2030.4.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 8 bytes of padding on 64 bit builds to reduce the size of
drm_open_hash to 24 bytes, which also shrinks drm_object_file by 24
bytes (136 -> 112) allowing it to fit in one fewer cache lines and a
smaller slab.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against v2.6.38-rc6
compiled & tested on x86_64 with nouveau.

regards
Richard



diff --git a/include/drm/drm_hashtab.h b/include/drm/drm_hashtab.h
index 0af087a..ff2ab48 100644
--- a/include/drm/drm_hashtab.h
+++ b/include/drm/drm_hashtab.h
@@ -48,8 +48,8 @@ struct drm_open_hash {
 	unsigned int size;
 	unsigned int order;
 	unsigned int fill;
-	struct hlist_head *table;
 	int use_vmalloc;
+	struct hlist_head *table;
 };
 
 


