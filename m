Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1IUHNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:13:08 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:56336 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1IUHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:13:06 -0400
Date: Wed, 21 Sep 2011 10:12:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Sam Bradshaw <sbradshaw@micron.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mtip32xx: double free if copy_from_user() fails
Message-ID: <20110921071250.GE4999@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E798E7E.00BB:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call kfree(req_task) after we go to abort so it isn't needed here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 847b8ff..0d23d8c 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1674,7 +1674,6 @@ static int exec_drive_taskfile(struct driver_data *dd,
 		intotal = compat_tasksize + req_task->out_size;
 	} else {
 		if (copy_from_user(req_task, buf, tasksize)) {
-			kfree(req_task);
 			err = -EFAULT;
 			goto abort;
 		}
