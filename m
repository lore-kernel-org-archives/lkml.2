Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2CUMOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:14:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35735 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2CUMOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:14:50 -0400
Message-ID: <4F69C630.3000604@kernel.org>
Date: Wed, 21 Mar 2012 20:14:40 +0800
From: Shaohua Li <shli@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "neilb@suse.de" <neilb@suse.de>, martin.petersen@oracle.com
Subject: [patch 2/2]scsi: use correct API to get request position and size
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Let sd driver use correct API to get request position and size.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  drivers/scsi/sd.c |    5 ++---
  1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/sd.c
===================================================================
--- linux.orig/drivers/scsi/sd.c	2012-03-21 18:09:55.302320287 +0800
+++ linux/drivers/scsi/sd.c	2012-03-21 18:17:50.705774450 +0800
@@ -539,9 +539,8 @@ static void sd_config_discard(struct scs
  static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct 
request *rq)
  {
  	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	struct bio *bio = rq->bio;
-	sector_t sector = bio->bi_sector;
-	unsigned int nr_sectors = bio_sectors(bio);
+	sector_t sector = blk_rq_pos(rq);
+	unsigned int nr_sectors = blk_rq_sectors(rq);
  	unsigned int len;
  	int ret;
  	char *buf;
