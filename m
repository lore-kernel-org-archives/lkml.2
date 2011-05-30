Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab1E3RDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 13:03:18 -0400
Received: from mail.ispras.ru ([83.149.199.43]:51355 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757346Ab1E3RDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 13:03:16 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/usb/catc.c: Fix potential deadlock in catc_ctrl_run()
Date: Mon, 30 May 2011 21:01:18 +0400
Message-Id: <1306774878-5471-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces GFP_KERNEL with GFP_ATOMIC.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/usb/catc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index d7221c4..8056f8a 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -495,7 +495,7 @@ static void catc_ctrl_run(struct catc *catc)
 	if (!q->dir && q->buf && q->len)
 		memcpy(catc->ctrl_buf, q->buf, q->len);
 
-	if ((status = usb_submit_urb(catc->ctrl_urb, GFP_KERNEL)))
+	if ((status = usb_submit_urb(catc->ctrl_urb, GFP_ATOMIC)))
 		err("submit(ctrl_urb) status %d", status);
 }
 
-- 
1.7.4.1

