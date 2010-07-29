Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab0G2PzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:55:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38102 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab0G2PzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=smsJjTbKCGAuXHnLHRvKXO0Wk6G9S7xO8EiMxU9p5yn01qW4YS+vO1e4WYD7k8LKlO
         DGWnPLsojLw3oxNpUP9mGTOb0xOd/MeM2rxhUBQT9OWgFCkn1Wqc66jD5AnXoXftzQJ6
         BxlxOczWc4s0+wC0EJ1Wb87G2951M+4fAtnaY=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Chirag Kantharia <chirag.kantharia@hp.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH] cpqarray: check put_user() result
Date: Thu, 29 Jul 2010 19:54:44 +0400
Message-Id: <1280418885-5630-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/block/cpqarray.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 9473215..d53b029 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -1179,7 +1179,8 @@ out_passthru:
 		return error;
 	case IDAGETCTLRSIG:
 		if (!arg) return -EINVAL;
-		put_user(host->ctlr_sig, (int __user *)arg);
+		if (put_user(host->ctlr_sig, (int __user *)arg))
+			return -EFAULT;
 		return 0;
 	case IDAREVALIDATEVOLS:
 		if (MINOR(bdev->bd_dev) != 0)
@@ -1187,7 +1188,8 @@ out_passthru:
 		return revalidate_allvol(host);
 	case IDADRIVERVERSION:
 		if (!arg) return -EINVAL;
-		put_user(DRIVER_VERSION, (unsigned long __user *)arg);
+		if (put_user(DRIVER_VERSION, (unsigned long __user *)arg))
+			return -EFAULT;
 		return 0;
 	case IDAGETPCIINFO:
 	{
-- 
1.7.0.4

