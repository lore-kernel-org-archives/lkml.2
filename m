Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2GHLiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 07:38:21 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:49825 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab2GHLhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 07:37:53 -0400
X-IronPort-AV: E=Sophos;i="4.77,546,1336341600"; 
   d="scan'208";a="166023138"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] mm/slub.c: remove invalid reference to list iterator variable
Date: Sun,  8 Jul 2012 13:37:40 +0200
Message-Id: <1341747464-1772-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If list_for_each_entry, etc complete a traversal of the list, the iterator
variable ends up pointing to an address at an offset from the list head,
and not a meaningful structure.  Thus this value should not be used after
the end of the iterator.  The patch replaces s->name by al->name, which is
referenced nearby.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index cc4ed03..ef9bf01 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5395,7 +5395,7 @@ static int __init slab_sysfs_init(void)
 		err = sysfs_slab_alias(al->s, al->name);
 		if (err)
 			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
-					" %s to sysfs\n", s->name);
+					" %s to sysfs\n", al->name);
 		kfree(al);
 	}
 

