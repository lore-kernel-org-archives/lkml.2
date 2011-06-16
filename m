Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab1FPH2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:28:42 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59469 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756256Ab1FPHFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:14 -0400
X-Sasl-enc: ufG8RxACLMLL9kw2aKtf29cMZt4G1L6mJU4/Nx4SQjXh 1308207913
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:10 2011
Message-Id: <20110616001610.183376203@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Radensky <felix@embedded-sol.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [09/91] mtd: mtdconcat: fix NAND OOB write
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -306,7 +306,7 @@ concat_write_oob(struct mtd_info *mtd, l
 	if (!(mtd->flags & MTD_WRITEABLE))
 		return -EROFS;
 
-	ops->retlen = 0;
+	ops->retlen = ops->oobretlen = 0;
 
 	for (i = 0; i < concat->num_subdev; i++) {
 		struct mtd_info *subdev = concat->subdev[i];
@@ -321,7 +321,7 @@ concat_write_oob(struct mtd_info *mtd, l
 			devops.len = subdev->size - to;
 
 		err = subdev->write_oob(subdev, to, &devops);
-		ops->retlen += devops.retlen;
+		ops->retlen += devops.oobretlen;
 		if (err)
 			return err;
 


