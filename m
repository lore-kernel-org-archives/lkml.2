Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab1AOODY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 09:03:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34808 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1AOODW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:03:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=sdtvJVczyzmrJTcw4LWmjyT0/e6ZHanoreemoX6cQQAHnyW/TEG59ekaSZib+sGGvp
         zoRbP1tlbYo7vAXDpWwiNK5+hmz0/dlq5x7rwRR5cMRIRVkbE/5DOstC8V3wS6Nzlhi5
         TtRMktVxOQB89DAFywSE+5wQZpmztomJHsGKU=
Date: Sat, 15 Jan 2011 17:03:00 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] target: checking for NULL instead of IS_ERR
Message-ID: <20110115140300.GC2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkdev_get_by_path() returns an ERR_PTR() or error and it doesn't return
a NULL.  It looks like this bug would be easy to trigger by mistake.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c6e0d75..3456135 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -154,7 +154,7 @@ static struct se_device *iblock_create_virtdevice(
 
 	bd = blkdev_get_by_path(ib_dev->ibd_udev_path,
 				FMODE_WRITE|FMODE_READ|FMODE_EXCL, ib_dev);
-	if (!(bd))
+	if (IS_ERR(bd))
 		goto failed;
 	/*
 	 * Setup the local scope queue_limits from struct request_queue->limits
