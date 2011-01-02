Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1ABHg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:36:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:36929 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab1ABHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 205/260] bsg: fix incorrect device_status value
Date: Sun,  2 Jan 2011 02:18:21 -0500
Message-Id: <1293952756-15010-206-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:54.0995 (UTC) FILETIME=[03503430:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 478971600e47cb83ff2d3c63c5c24f2b04b0d6a1 upstream.

bsg incorrectly returns sg's masked_status value for device_status.

[jejb: fix up expression logic]
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 block/bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..0c00870 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -426,7 +426,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = rq->errors & 0xff;
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
-- 
1.7.3.3

