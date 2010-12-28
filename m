Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0L1RaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:30:20 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:44628 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0L1R3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MA31Xr5qeOxr8Ht5Yr2ndY41Y8FiaVGIpSDYNMcRBSjYLF7qNJ1mBOHphddjQjhotZ
         3Uktv0vGl8hLYSK7Irti8QpJM1LDplhs5VTyoaUvvzseQZ8h79fCcKZS7QKXUQaY4cQ2
         TVPA6fMp1Z0lPCTtG+YmPG2rtSd3XLE/6R2Xk=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/16] umem: drop dummy ->media_changed()
Date: Tue, 28 Dec 2010 18:29:10 +0100
Message-Id: <1293557352-10592-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

umem doesn't implement media changed detection and there's no need to
implement dummy callback anymore.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/umem.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 8be5715..9b102ab 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -779,20 +779,10 @@ static int mm_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return 0;
 }
 
-/*
- * Future support for removable devices
- */
-static int mm_check_change(struct gendisk *disk)
-{
-/*  struct cardinfo *dev = disk->private_data; */
-	return 0;
-}
-
 static const struct block_device_operations mm_fops = {
 	.owner		= THIS_MODULE,
 	.getgeo		= mm_getgeo,
 	.revalidate_disk = mm_revalidate,
-	.media_changed	= mm_check_change,
 };
 
 static int __devinit mm_pci_probe(struct pci_dev *dev,
-- 
1.7.1

