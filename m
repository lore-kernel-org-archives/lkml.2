Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab1LGUcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:32:43 -0500
Received: from mxout1.idt.com ([157.165.5.25]:39699 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab1LGUcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:32:42 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: [PATCH RESEND] rapidio/tsi721: Fix mailbox resource reporting
Date: Wed,  7 Dec 2011 15:31:14 -0500
Message-Id: <1323289875-25559-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bug fix for Tsi721 RapidIO mport driver:
Tsi721 supports four RapidIO mailboxes (MBOX0 - MBOX3) as defined by RapidIO
specification. Mailbox resources has to be properly reported to allow use
of all available mailboxes (initial version reports only MBOX0).

This patch is applicable to kernel versions staring from 3.2-rc1.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
---

[Resending this patch with updated commit comment]

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

