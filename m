Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab1LFTCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:02:45 -0500
Received: from mxout1.idt.com ([157.165.5.25]:55676 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab1LFTCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:02:43 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH] rapidio/tsi721: Fix mailbox resource reporting
Date: Tue,  6 Dec 2011 14:01:27 -0500
Message-Id: <1323198088-11669-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report support of four RapidIO mailboxes (MBOX0 - MBOX3) instead of MBOX0
only.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
---
 drivers/rapidio/devices/tsi721.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 514c28c..83ac8728 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -2107,8 +2107,8 @@ static int __devinit tsi721_setup_mport(struct tsi721_device *priv)
 	INIT_LIST_HEAD(&mport->dbells);
 
 	rio_init_dbell_res(&mport->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
-	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 0);
-	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 0);
+	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 3);
+	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 3);
 	strcpy(mport->name, "Tsi721 mport");
 
 	/* Hook up interrupt handler */
-- 
1.7.6

