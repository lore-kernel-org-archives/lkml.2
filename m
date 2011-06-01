Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161327Ab1FAII6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:08:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161268Ab1FAIIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:08:54 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:57 2011
Message-Id: <20110601080257.422039041@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:26 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Radensky <felix@embedded-sol.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [030/146] mtd: mtdconcat: fix NAND OOB write
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Radensky <felix@embedded-sol.com>

commit 431e1ecabddcd7cbba237182ddf431771f98bb4c upstream.

Currently mtdconcat is broken for NAND. An attemtpt to create
JFFS2 filesystem on concatenation of several NAND devices fails
with OOB write errors. This patch fixes that problem.

Signed-off-by: Felix Radensky <felix@embedded-sol.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/mtdconcat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/mtdconcat.c
+++ b/drivers/mtd/mtdconcat.c
@@ -319,7 +319,7 @@ concat_write_oob(struct mtd_info *mtd, l
 	if (!(mtd->flags & MTD_WRITEABLE))
 		return -EROFS;
 
-	ops->retlen = 0;
+	ops->retlen = ops->oobretlen = 0;
 
 	for (i = 0; i < concat->num_subdev; i++) {
 		struct mtd_info *subdev = concat->subdev[i];
@@ -334,7 +334,7 @@ concat_write_oob(struct mtd_info *mtd, l
 			devops.len = subdev->size - to;
 
 		err = subdev->write_oob(subdev, to, &devops);
-		ops->retlen += devops.retlen;
+		ops->retlen += devops.oobretlen;
 		if (err)
 			return err;
 


