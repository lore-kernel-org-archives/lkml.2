Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2C0Is0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:48:26 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:47594 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab2C0IsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:48:25 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 04:48:25 EDT
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q2R8hNk8001667, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH 3/3] staging:rts_pstor:Avoid "Bad target number" message when probing driver
Date: Tue, 27 Mar 2012 16:43:20 +0800
Message-ID: <1332837800-9765-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Avoid "Bad LUN" and "Bad target number" message by setting the supported
max_lun and max_id for the scsi host

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/rtsx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index a7feb3e..1dccd93 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -1000,6 +1000,11 @@ static int __devinit rtsx_probe(struct pci_dev *pci,
 
 	rtsx_init_chip(dev->chip);
 
+	/* set the supported max_lun and max_id for the scsi host
+	 * NOTE: the minimal value of max_id is 1 */
+	host->max_id = 1;
+	host->max_lun = dev->chip->max_lun;
+
 	/* Start up our control thread */
 	th = kthread_run(rtsx_control_thread, dev, CR_DRIVER_NAME);
 	if (IS_ERR(th)) {
-- 
1.7.5.4

