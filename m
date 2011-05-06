Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1EFS2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:28:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55860 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab1EFS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=KLcN5Q7kplk7LtkRbEQlw2OViM2MvaQ8VT4242PGTsh0U46KWarNbnv5BatZYniwTW
         OriHXjLie9yZjhxyAflNfAAgVVJu1FLgOUgbMVPHhmizGNUqXB7M4+cJi7fuBtbM+IqY
         HwHhyBspl+mPhi+WDMn4/HRPfH2JXqtzu+yy8=
MIME-Version: 1.0
Date: Fri, 6 May 2011 21:28:04 +0300
Message-ID: <BANLkTi=Jdxu7am8-jhJbT0t-uhNmW4zWhw@mail.gmail.com>
Subject: [PATCH] slub: slub_def.h: needs additional check for "index"
From: Maxin John <maxin.john@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In slub_def.h file, the kmalloc_index() may return -1 for some special cases.
If that negative return value gets assigned to "index", it might lead to issues
later as the variable "index" is used as index to array "kmalloc_caches" in :

return kmalloc_caches[index];

Please let me know your comments.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
---
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 45ca123..3db4b33 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -211,7 +211,7 @@ static __always_inline struct kmem_cache
*kmalloc_slab(size_t size)
 {
        int index = kmalloc_index(size);

-       if (index == 0)
+       if (index <= 0)
                return NULL;

        return kmalloc_caches[index];
