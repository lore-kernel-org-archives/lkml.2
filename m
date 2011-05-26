Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab1EZM4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:56:09 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:51405 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1EZM4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LtFDZN4GqDH1sNjY4ym4bgcZMN8BzuEpjrgV2osJlltpRqhSRCaPqjlvOOOvfNM6ow
         kA89tfYJbLM+2W5Ms1rN4MzMb6K5rOYShdRxeR80cvTNHdmx8ZvBVx5Eh1aBSMB3PHGV
         xmeuQaIvqqnnam+XybSzLi7ldFYtVIt7vlmvY=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] brd: get rid of unused members from struct brd_device
Date: Thu, 26 May 2011 21:55:53 +0900
Message-Id: <1306414557-2441-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
References: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

brd_refcnt, brd_offset, brd_sizelimit and brd_blocksize in struct
brd_device seem to be copied from struct loop_device but they're
not used anywhere. Let get rid of them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/block/brd.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index b7f51e4594f8..bae9a3d4e15b 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -35,10 +35,6 @@
  */
 struct brd_device {
 	int		brd_number;
-	int		brd_refcnt;
-	loff_t		brd_offset;
-	loff_t		brd_sizelimit;
-	unsigned	brd_blocksize;
 
 	struct request_queue	*brd_queue;
 	struct gendisk		*brd_disk;
-- 
1.7.5.2

