Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1FPHOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:14:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49579 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756565Ab1FPHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:31 -0400
X-Sasl-enc: 2CmmQB5QlspzoVLw5rw45D/xOWoJw4iSRrj+7AP+NFQu 1308208290
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:11 2011
Message-Id: <20110616002911.477899101@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Namhyung Kim <namhyung@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [76/85] md/raid5: fix raid5_set_bi_hw_segments
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Namhyung Kim <namhyung@gmail.com>

commit 9b2dc8b665932a8e681a7ab3237f60475e75e161 upstream.

The @bio->bi_phys_segments consists of active stripes count in the
lower 16 bits and processed stripes count in the upper 16 bits. So
logical-OR operator should be bitwise one.

This bug has been present since 2.6.27 and the fix is suitable for any
-stable kernel since then.  Fortunately the bad code is only used on
error paths and is relatively unlikely to be hit.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -127,7 +127,7 @@ static inline int raid5_dec_bi_hw_segmen
 
 static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
+	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
 }
 
 /* Find first data disk in a raid6 stripe */


