Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab1CIJPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:15:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39278 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab1CIJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:15:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=b0NLHVe7Sp2Qhjs6Pt3dYYaN29WKEN61dg/P1nXLWOb7CCdaTbVjgfFTf1rIT3Z6J6
         VLacK9TgdjI/UI5puIsFg4ZnnvJ1KS72JsufP9xEFmgqzMtZ6QNsC8mM4UFSVZA3jVt4
         +Z728xntCxrEz2SZde3FNScJ2tvyRyVJnT7t8=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/16] umem: Drop dummy ->media_changed()
Date: Wed,  9 Mar 2011 10:13:34 +0100
Message-Id: <1299662016-7721-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
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

