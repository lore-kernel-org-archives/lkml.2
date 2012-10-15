Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2JOUV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:21:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab2JOUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:13 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com
Subject: [PATCH v4 17/24] raid1: use bio_copy_data()
Date: Mon, 15 Oct 2012 13:08:51 -0700
Message-Id: <1350331769-14856-18-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't really delete any code _yet_, but once immutable bvecs are
done we can just delete the rest of the code in that loop.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index af39f74..1c40d90 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1895,10 +1895,9 @@ static int process_checks(struct r1bio *r1_bio)
 			else
 				bi->bv_len = size;
 			size -= PAGE_SIZE;
-			memcpy(page_address(bi->bv_page),
-			       page_address(pbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
 		}
+
+		bio_copy_data(sbio, pbio);
 	}
 	return 0;
 }
-- 
1.7.12

