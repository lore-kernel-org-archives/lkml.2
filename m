Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2FQVHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:07:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60669
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758013Ab2FQVGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:06:34 -0400
Message-Id: <20120617210632.922931341@bombadil.infradead.org>
User-Agent: quilt/0.48-1
Date: Sun, 17 Jun 2012 17:05:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janne Kalliom??ki <janne@tuxera.com>
Subject: [PATCH 1/2] hfsplus: fix overflow in sector calculations in hfsplus_submit_bio
References: <20120617210523.088906451@bombadil.infradead.org>
Content-Disposition: inline; filename=hfsplus-mount-fix.diff
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable io_size was unsigned int, which caused the wrong sector number
to be calculated after aligning it. This then caused mount to fail with big
volumes, as backup volume header information was searched from a
wrong sector.

Signed-off-by: Janne Kalliom??ki <janne@tuxera.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/hfsplus/wrapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 5d2aa0c..1cc3920 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -70,7 +70,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
 	int ret = 0;
-	unsigned int io_size;
+	u64 io_size;
 	loff_t start;
 	int offset;
 

