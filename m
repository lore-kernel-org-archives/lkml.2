Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1JaHDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 03:03:10 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57098 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1JaHDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 03:03:09 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.15 with qID p9V72sbk021433, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging:rts_pstor:Complete scanning_done variable
Date: Mon, 31 Oct 2011 15:02:53 +0800
X-BOX-Message-Id: p9V72sbk021433
Message-ID: <1320044573-22195-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Complete scanning_done variable if rtsx-scan thread created failed.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/rtsx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 480b0ed..115635f 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -1021,6 +1021,7 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 	th = kthread_create(rtsx_scan_thread, dev, "rtsx-scan");
 	if (IS_ERR(th)) {
 		printk(KERN_ERR "Unable to start the device-scanning thread\n");
+		complete(&dev->scanning_done);
 		quiesce_and_remove_host(dev);
 		err = PTR_ERR(th);
 		goto errout;
-- 
1.7.5.4

