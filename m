Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1BOPQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:16:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab1BOPQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:16:35 -0500
Message-ID: <4D5A98C7.3070803@redhat.com>
Date: Tue, 15 Feb 2011 16:16:23 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org
Subject: [PATCH] Return EROFS if read-only detected on block device
References: <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma>	<4D580A8B.5050508@redhat.com>	<20110214103026.GA18742@htj.dyndns.org>	<4D591664.6090203@redhat.com> <4D592AD1.6020500@redhat.com>	<20110214140940.GM18742@htj.dyndns.org>	<4D593AD8.7070901@redhat.com>	<20110214154430.GR18742@htj.dyndns.org>	<20110215101506.43d41ca8@notabene.brown>	<20110215020351.GD5825@agk-dp.fab.redhat.com> <4D5A6EF4.3030905@redhat.com>
In-Reply-To: <4D5A6EF4.3030905@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows userspace to distinguish what is going on.

EACCES is returned when user lacks required capability,
not that device is read-only.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 fs/block_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c9cf9f7..db2c8db 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1219,7 +1219,7 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 	/* __blkdev_get() may alter read only status, check it afterwards */
 	if (!res && (mode & FMODE_WRITE) && bdev_read_only(bdev)) {
 		__blkdev_put(bdev, mode, 0);
-		res = -EACCES;
+		res = -EROFS;
 	}
 
 	if (whole) {



