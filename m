Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1E0G1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:27:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34003 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1E0G1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:27:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MSpDzAIlP/Y4/lEbhDGO2SpkvFmZ1PXhoV0B87UXT5BKR5X9U4mwOceZGDQx+c6x6c
         A5+LB+IqVsCqClTAyuFBWom6CyYN9tM8WDUYQLwip3AyHCsYJLWxzT/VLAsTYf3PojAz
         SLIZz1OWRs9enMqNd3DA/E0XgNj5ETAAE/qZo=
Date: Fri, 27 May 2011 09:27:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <jbeulich@novell.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] xen/blkback: potential null dereference in error handling
Message-ID: <20110527062701.GK14591@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkbk->pending_pages can be NULL here so I added a check for it.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Perhaps this is not the a very optimized solution, but it's error
handling code so it's not performance critical.

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c73910c..1c7a59d 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -810,7 +810,7 @@ static int __init xen_blkif_init(void)
 	kfree(blkbk->pending_reqs);
 	kfree(blkbk->pending_grant_handles);
 	for (i = 0; i < mmap_pages; i++) {
-		if (blkbk->pending_pages[i])
+		if (blkbk->pending_pages && blkbk->pending_pages[i])
 			__free_page(blkbk->pending_pages[i]);
 	}
 	kfree(blkbk->pending_pages);
