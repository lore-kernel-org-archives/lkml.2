Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1HYJK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 05:10:29 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56335 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1HYJKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:10:25 -0400
X-AuditID: b753bd60-a287bba0000050a4-39-4e56117f77a9
X-AuditID: b753bd60-a287bba0000050a4-39-4e56117f77a9
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [-v3 PATCH 2/3] sd: [cleanup] Use sd_printk() instead of printk()
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        James.Bottomley@HansenPartnership.com,
        dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Nao Nishijima <nao.nishijima.xt@hitachi.com>
Date: Thu, 25 Aug 2011 18:04:14 +0900
Message-ID: <20110825090414.2288.11722.stgit@ltc197.sdl.hitachi.co.jp>
In-Reply-To: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd_ioctl() still use printk() for log output.
It should use sd_printk() instead of printk(), as well as other sd_*.

All SCSI messages should output via s*_printk() instead of printk().

Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 drivers/scsi/sd.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773c..a7942e5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1066,12 +1066,13 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	struct scsi_device *sdp = scsi_disk(disk)->device;
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_device *sdp = sdkp->device;
 	void __user *p = (void __user *)arg;
 	int error;
     
-	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
-						disk->disk_name, cmd));
+	SCSI_LOG_IOCTL(1, sd_printk(KERN_INFO, sdkp, "sd_ioctl: disk=%s, "
+				    "cmd=0x%x\n", disk->disk_name, cmd));
 
 	/*
 	 * If we are in the middle of error recovery, don't let anyone

