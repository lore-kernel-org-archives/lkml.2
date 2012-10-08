Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab2JHPgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:36:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44271 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2JHPgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:36:37 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alex Dubov <oakad@yahoo.com>, Linux-Next <linux-next@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/2] memstick: remove unused field from state struct.
Date: Mon,  8 Oct 2012 17:36:21 +0200
Message-Id: <1349710582-5410-2-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349710582-5410-1-git-send-email-maximlevitsky@gmail.com>
References: <CAMuHMdW7zfM1CxkXTCq2=ErkaAAxGVFyQSZdH3jwvUXr_8oOsg@mail.gmail.com>
 <1349710582-5410-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, I forgot that I have thet field there already.
Just save memory by not allocating it.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/ms_block.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/memstick/core/ms_block.h b/drivers/memstick/core/ms_block.h
index 6b5b83e..a2b2765 100644
--- a/drivers/memstick/core/ms_block.h
+++ b/drivers/memstick/core/ms_block.h
@@ -162,7 +162,6 @@ struct msb_data {
 	struct workqueue_struct		*io_queue;
 	bool				io_queue_stopped;
 	struct work_struct		io_work;
-	struct scatterlist		prealloc_sg[MS_BLOCK_MAX_SEGS+1];
 	bool				card_dead;
 
 	/* Media properties */
@@ -194,7 +193,7 @@ struct msb_data {
 
 	/* Preallocated buffers */
 	unsigned char			*block_buffer;
-	struct scatterlist		sg[MS_BLOCK_MAX_SEGS+1];
+	struct scatterlist		prealloc_sg[MS_BLOCK_MAX_SEGS+1];
 
 
 	/* handler's local data */
-- 
1.7.9.5

