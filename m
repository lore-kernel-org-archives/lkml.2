Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0H1OJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:09:49 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:45028 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab0H1OJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:09:48 -0400
Subject: [PATCH] mm:  remove alignment padding from anon_vma on (some) 64
 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Aug 2010 15:09:46 +0100
Message-ID: <1283004586.1912.10.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder structure anon_vma to remove alignment padding on 64 builds when
(CONFIG_KSM || CONFIG_MIGRATION).
This will shrink the size of the anon_vma structure from 40 to 32 bytes
& allow more objects per slab in its kmem_cache.

Under slub the objects in the anon_vma kmem_cache will then be 40 bytes
with 102 objects per slab.
(On v2.6.36 without this patch,the size is 48 bytes and 85
objects/slab.)
    
compiled & tested on x86_64 using SLUB
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against v2.6.36-rc2
compiled & tested on x86_64 AMD X2  

regards
Richard


diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 31b2fd7..5c98df6 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -25,8 +25,8 @@
  * pointing to this anon_vma once its vma list is empty.
  */
 struct anon_vma {
-	spinlock_t lock;	/* Serialize access to vma list */
 	struct anon_vma *root;	/* Root of this anon_vma tree */
+	spinlock_t lock;	/* Serialize access to vma list */
 #if defined(CONFIG_KSM) || defined(CONFIG_MIGRATION)
 
 	/*


