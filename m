Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1HZF6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 01:58:04 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39781 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1HZF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 01:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>
References: <CADqbE97Vj0UV-2XvpkoELwdey_Xw7iCsF1AhQNFjwxY583SUwg@mail.gmail.com>
Date: Fri, 26 Aug 2011 13:58:01 +0800
Message-ID: <CADqbE95wqM9GFVofQ=pnv9t52ES_86DvwbUwuesO42gOteD2aw@mail.gmail.com>
Subject: Re: [PATCH] slab: avoid unnecessary touching of a partial slab
From: Zhao Jin <cronozhj@gmail.com>
To: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com,
        trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, one line in this patch does not conform to the coding style of
kernel source code. Here is the corrected version:

---
 mm/slab.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 6d90a09..0c7a212 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3121,11 +3121,13 @@ retry:
 		check_slabp(cachep, slabp);

 		/* move slabp to correct slabp list: */
-		list_del(&slabp->list);
-		if (slabp->free == BUFCTL_END)
+		if (slabp->free == BUFCTL_END) {
+			list_del(&slabp->list);
 			list_add(&slabp->list, &l3->slabs_full);
-		else
+		} else if (&slabp->list != l3->slabs_partial.next) {
+			list_del(&slabp->list);
 			list_add(&slabp->list, &l3->slabs_partial);
+		}
 	}

 must_grow:
-- 
1.7.4.1
