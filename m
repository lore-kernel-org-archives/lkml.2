Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1BJFf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:35:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47203 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab1BJFf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:35:27 -0500
Date: Thu, 10 Feb 2011 16:35:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20110210163527.3b2cc580.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/zram/zram_drv.c between commit
5414e557fca545614ceedc3d3496f747457e2e3b ("staging: zram: fix data
corruption issue") from the staging.current tree and commit
2787f959d6c5fb258d964218ac75346019f49ee9 ("zram: Return zero'd pages on
new reads") from the staging tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/zram/zram_drv.c
index 4bd8cbd,1017d6d..0000000
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@@ -235,8 -237,7 +238,8 @@@ static void zram_read(struct zram *zram
  		if (unlikely(!zram->table[index].page)) {
  			pr_debug("Read before write: sector=%lu, size=%u",
  				(ulong)(bio->bi_sector), bio->bi_size);
- 			/* Do nothing */
+ 			handle_zero_page(page);
 +			index++;
  			continue;
  		}
  
